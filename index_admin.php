<?php
if( !defined("INSIGHTS_RUNNING") ) die("Error 211.");

# ============================================================================
# messy, cleanup later
# ============================================================================
if( defined('VOA_DISABLE_FOOTER') ) {
	$VOA->assign('disable_footer', true);
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

