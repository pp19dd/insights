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
 			
			# for this safety filter, try_type is cooerced into an array
			global $ALLOW_TYPE;
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
		
		case 'merge':

			# make sure term ids exist
			if(
				!isset( $_POST['terms_to_merge']) || 
				!is_array( $_POST['terms_to_merge']) || 
				empty( $_POST['terms_to_merge']))
			{
				die( "Error: terms not listed/specified");
			}
			$terms = array();
			foreach( $_POST['terms_to_merge'] as $term ) {
				$terms[] = intval( $term );
			}
			
			# for this safety filter, try_type is cooerced into an array
			$term_type = $_POST['term_type'];
			global $ALLOW_TYPE;
			$tbl = TABLE_PREFIX;
			$type = array_intersect($ALLOW_TYPE, array($term_type) );
			if( empty( $type ) ) {
				die( "Error: term type not allowed");
			}
			$type = array_shift( $type );

			# simple int
			$reassign_to = intval( $_POST['reassign_to'] );
			
			# do the merge
 			$VOA->query(
 				"update `{$tbl}map` set `other_id`=%s where `other_id` in (%s) and `type`='%s' and `is_deleted`='No'",
				$reassign_to,
				implode(",", $terms),
				$type
 			);
			
//			ob_start();
// 			$ret["test"] = "testing";
// 			echo "<PRE>";
// 			print_r( $_POST );
// 			print_r( $terms );
// 			echo "</PRE>";
// 			$ret["html"] = ob_get_clean();
			$ret["status"] = "good";
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

