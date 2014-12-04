<?php
# ============================================================================
# api: provides three functions
#      1 - data output				performed by main, live server
#      2 - data retrieval			 * performed by dev server only
#      3 - data ingestion 			 * performed by dev server only
# ============================================================================
# to talk to the api, post a key, action and format
# ============================================================================
# $_POST['key']		should correspond to API_KEY located in config.php
# $_POST['format']	json | serialize | text
#
# $_POST['action']  for main server: list | dump 
# $_POST['action']  for dev server: wipe | sync
# ============================================================================
die( "api disabled" );
require( 'init.php' );

ob_start("ob_gzhandler");

$_POST['key'] = API_KEY; $_POST['action'] = "sync"; $_POST['format'] = "serialize";


foreach( array("key", "action", "format") as $parameter ) {
	if( !isset( $_POST[$parameter]) ) {
		printf( "Error - parameter %s invalid or missing.", $parameter );
		die;
	}
}

if( $_POST['key'] !== API_KEY ) {
	echo "Error - invalid API KEY.";
	die;
}

$API = new Insights_API( SYNC_URL, API_KEY );


$ret = array();
switch( $_POST['action'] ) {
	case 'list': $ret = $API->getList(); break;
	case 'dump': $ret = $API->getDump(); break;	
	
	case 'wipe':
		if( !defined("INSIGHTS_DEVELOPMENT") ) {
			echo "action wipe only available on development servers";
			die;
		}
		
		$API->doWipe();
	break;
	
	case 'sync':
		if( !defined("INSIGHTS_DEVELOPMENT") ) {
			echo "action sync only available on development servers";
			die;
		}
	
		if( !defined("SYNC_URL") ) {
			echo "error: SYNC_URL not defined. check config.php ?";
			die;
		}
		
		$remote_data = $API->doSync();
		
		if( $remote_data['status'] === false ) {
			echo "error unserializing data:<hr/><pre style='background-color:#FFE0E0; padding:1em'>";
			echo $remote_data['message'];
			echo "</PRE>";
			die;
		}
		
		$API->importData( $remote_data["data"] );
		$ret["remote data size"] = $remote_data["size"];
		
	break;
}

switch( $_POST['format'] ) {
	case 'json': echo json_encode( $ret ); break;
	case 'serialize': echo serialize( $ret ); break;
	case 'text': echo "<PRE>"; print_r( $ret ); break;
}
