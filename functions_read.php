<?php
if( !defined("INSIGHTS_RUNNING") ) die("Error 211.");

/**
 * retrieves full listing for an entry from a metadata table
 * 
 * @param $table String Partial table ex: beats, services, etc
 * @param $is_deleted String Yes or No
 * @param $id Integer table.id
 */
function resolve_map($table, $id, $is_deleted = 'No') {
	global $VOA;
	$tbl = TABLE_PREFIX;

	$t = $VOA->query(
		"select * from `{$tbl}%s` where `id`=%s and `is_deleted`='%s'",
		$table,
		intval($id),
		$is_deleted,
		array("noempty", "flat")
	);

	return( $t );
}

/**
 * returns metadata for a particular entry (reporters, beats, divisions, etc)
 * 
 * @param $entry_id int corresponds to insights_entry.id
 * @param $is_deleted String "Yes" or "No"
 */

function insights_map($entry_id, $is_deleted = 'No') {
	global $VOA;
	global $ALLOW_TYPE;
	$tbl = TABLE_PREFIX;

	$t = $VOA->query(
		"select 
			* 
		from 
			`{$tbl}map` 
		where 
			`entry_id`=%s and `is_deleted`='%s'",
		intval( $entry_id ),
		$is_deleted,
		array(
			"noempty", 
			"index" => "type",
			"deep",
			"index2" => "other_id"
		)
	);
	
	// mapping routine should show all pertinent types
	foreach( $ALLOW_TYPE as $v ) {
		if( !isset($t[$v])) $t[$v] = array();
	}
	
	// $k = reporters, beats
	foreach( $t as $k => $v ) {
	
		// $k2 = 0,1,2,3   $v2 = [type, entry_id, other_id], [...]
		foreach( $t[$k] as $k2 => $v2 ) {
			$t[$k][$k2]['resolved'] = resolve_map(
				$v2['type'],
				$v2['other_id'],
				$is_deleted
			);
		}
		
	}
	
	return( $t );
}


/**
 * returns number of actual map entries (can detect empty)
 */
function insights_map_count( &$map ) {
	$count = 0;
	foreach( $map as $k => $v ) {
		$count += count($v);
	}
	return( $count );
}

/**
 * retrieves entries
 * 
 * @param $options		Array		("mode" => "all", "range", "ids", "today", "custom")
 * @param $options		Array		("list" => array(1,3,4,5...))
 * @param $options		Array		("from" => "YYYY-MM-DD", "to" => "YYYY-MM-DD")
 */

function insights_get_entries( $options = array() ) {
	$t = insights_get_entries_rich( $options );

	// possible error
	if( empty($t) ) return( $t );
	
	return( $t["results"] );
}

function insights_get_entries_rich( $options = array() ) {
	global $VOA;
	$tbl = TABLE_PREFIX;
	$where = array("1");
	
	/* supposed to be not set?
	if( isset( $options["mode"]) ) {
		return( false );
	}*/
	
	if( isset( $options["stop"]) ) {
		return( array() );
	}
	
	if( isset( $options["cameras"]) ) {
		$where[] = sprintf( "`camera_assigned`='%s'", $options["cameras"] );
	}
	
	// is_deleted
	if( isset( $options["deleted"]) ) {
		$where[] = sprintf( "`is_deleted`='%s'", $options["deleted"] );
	}
	
	// $id = Array( 1, 2, 3, ... )
	if( isset( $options["id"]) ) {
		$where[] = sprintf( "`id` in (%s)", implode(",", $options["id"]) );
	}
	
	// hold for release (deadline = null)
	if( isset( $options["HFR"]) ) {
		
		$where[] = "`deadline` IS NULL";

	} else {

		if( isset( $options["date"]) ) {
		
			// $date = Array (YYYY-mm-dd, ...)
		
			foreach( $options["date"] as $k => $v ) {
				$options["date"][$k] = insights_filter_date($v);
			}
		
			$where[] = sprintf( "`deadline` in ('%s')", implode("','", $options["date"]) );
		}

		// $range = Array( "from" => "YYYY-mm-dd", "to" => "YYYY-mm-dd" )
		// assume range is +1 day. for a single day query, from = 2014-03-18, to = 2014-03-19
		if( isset( $options["from"]) && isset($options["to"]) ) {
			$where[] = sprintf( "`deadline` >= '%s'", insights_filter_date($options["from"]) );
			$where[] = sprintf( "`deadline` <= '%s'", insights_filter_date($options["to"]) );
		}
		
	}

	
	// $search = Array( "word", "word2..." );
	if( isset( $options["search"]) ) {
		
		$keywords_sql = array();
		foreach( $options["search"] as $k => $v ) {
			$keywords_sql[] = sprintf( "`slug` like '%%%s%%' or `description` like '%%%s%%'", $v, $v );
		}
		$where[] = implode(") and (", $keywords_sql );
		
	}
	
	# unified query
	$where_flat = implode( ") and (", $where);
	$VOA->sql = "select * from `{$tbl}entries` where ({$where_flat})";
	
	
	$VOA->options = array();		# preserve options, since this is a manual query
	$VOA->options[] = "noempty";
	$VOA->options["index"] = "id";
	$t = $VOA->query_raw();
	$VOA->options = array();		# restore options
	
	# get metadata for the entries
	foreach( $t as $k => $v ) {
		$t[$k]['map'] = insights_map( $v['id']/*, $is_deleted*/ );
		$t[$k]['map_count'] = insights_map_count( $t[$k]['map'] );
	}
	
	return( array(
		"results" => $t,
		"where" => $where,
		"sql" => $VOA->sql			
	));
}
