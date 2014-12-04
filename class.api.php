<?php

class Insights_API {

	var $tables = array();
	var $sync_url = "";
	var $key = "";
	
	function __construct( $sync_url, $key ) {

		$this->sync_url = $sync_url;
		$this->key = $key;
		
		global $INSIGHTS_TABLES;
		global $ALLOW_TYPE;
		
		$this->tables = array_merge( $INSIGHTS_TABLES, $ALLOW_TYPE );
		foreach( $this->tables as $k => $table ) {
			$tables[$k] = sprintf( "%s%s", TABLE_PREFIX, $table);
		}
		
	}
	
	function getList() {
		global $VOA;
		
		$ret = array();
		foreach( $this->tables as $table ) {
			$count = $VOA->query( "select count(*) as `count` from `%s`", $table, array("flat") );
			$ret[$table] = $count["count"];
		}

		return( $ret );
	}
	
	function getDump() {
		global $VOA;
		
		$ret = array();
		foreach( $this->tables as $table ) {
			$ret[$table] = $VOA->query( "select * from `%s`", $table, array("noempty") );
		}
		
		return( $ret );
	}
	
	function doWipe() {
		global $VOA;
		
		foreach( $this->tables as $table ) {
			$VOA->query( "truncate `%s`", $table );
		}
	}
	
	function doSync() {
		$ret = array(
			"status" => true
		);
		
		$ch = curl_init();
		curl_setopt( $ch, CURLOPT_URL, $this->sync_url );
		curl_setopt( $ch, CURLOPT_POST, 1 );
		curl_setopt( $ch, CURLOPT_POSTFIELDS, sprintf(
			"key=%s&format=serialize&action=dump",
			$this->key
		));
		curl_setopt( $ch, CURLOPT_RETURNTRANSFER, true );
		$remote_data_raw = curl_exec( $ch );
		curl_close( $ch );
		
		$remote_data = @unserialize($remote_data_raw);
		
		if( $remote_data === false ) {
			$ret["status"] = false;
			$ret["message"] = $remote_data_raw;
		}
		$ret['data'] = $remote_data;
		$ret["size"] = strlen( $remote_data_raw );
		
		return($ret);
	}
	
	function sanitize( $arr ) {
		$temp = array();
		foreach( $arr as $k => $v ) {
			$temp[$k] = mysql_real_escape_string( $v ); 
		}
		return( $temp );
	}
	
	function importData( &$data ) {
		global $VOA;
		
		foreach( $data as $table => $entries ) {
			foreach( $entries as $entry ) {

				$item = $entry;
				unset( $item["id"] ); // autoincr
				
				$keys = $this->sanitize( array_keys( $item ) );
				$values = $this->sanitize( array_values( $item ) );
				
				$sql = sprintf("insert into `%s` (`%s`) values ('%s')",
					$table,
					implode("`, `", $keys),
					implode("', '", $values)
				);
				
				$VOA->query( $sql );
			}
		}
		
	}
}
