<?php
if( !defined("INSIGHTS_RUNNING") ) die("Error 211.");

# ============================================================================
# messy, cleanup later
# ============================================================================
if( defined('VOA_DISABLE_FOOTER') ) {
	$VOA->assign('disable_footer', true);
}

# ============================================================================
# ajax mode, control panel
# ============================================================================
if( isset( $_POST['ajax']) && isset( $_POST['action'] ) ) {
	
	$ret = array();
	switch( $_POST['action'] ) {
		case 'rename':

			$term_id = intval($_POST['term_id']);
			$term_name = trim(strip_tags($_POST['term_name']));
			$term_type = $_POST['term_type'];
 			
			global $ALLOW_TYPE;
			
			# for this safety filter, try_type is cooerced into an array
			$tbl = TABLE_PREFIX;
			$type = array_intersect($ALLOW_TYPE, array($term_type) );
			
			if( empty( $type ) ) {
				die( "Error: term type not allowed");
			}
			
			$type = array_shift( $type );
			
 			$VOA->query(
 				"update `{$tbl}{$type}` set `name`='%s' where `id`=%s limit 1",
 				$term_name,
				$term_id
			);
			$ret["status"] = "good";
			$ret["term_name"] = $term_name;
			$ret["term_id"] = $term_id;
		break;
		
	}
	
	echo json_encode($ret);
	die;
}

# ============================================================================
# admin-related queries
# ============================================================================
$queries = insights_get_common_queries();

// #pre( $queries );
// foreach( $queries["reporters"] as $k => $v ) {
// 	$tbl = TABLE_PREFIX;
	
// 	$count = $VOA->query(
// 		"select count(*) as `count` from {$tbl}map where type='reporters' and other_id={$v["id"]}",
// 		array("flat")
// 	);
	
// 	#pre( $count );
// 	$queries["reporters"][$k]["count"] = $count["count"];
// }


foreach( $queries as $query => $data ) {
	$VOA->assign( $query, $data );
}

