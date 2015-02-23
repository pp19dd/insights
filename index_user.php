<?php
if( !defined("INSIGHTS_RUNNING") ) die("Error 211.");

// user mode

# ============================================================================
# bare minimum required for navigation: range, and day (date_start)
# ============================================================================
$URL = new Rewrite_URL();
if( !isset( $_GET['range'] )) 	$URL->set( "range", "day" );
if( !isset( $_GET['day'] )) 	$URL->set( "day", date("Y-m-d") );

// watchlist: stop now and merge a watchlist
if( isset( $_GET['watch']) ) {

	$watch_a = insights_get_watchlist();
	$watch_b = insights_string_to_watchlist( $_GET['watch'] );
	$watch_c = array_unique(array_merge($watch_a, $watch_b));

	insights_save_watchlist( $watch_c );
	header("location:" . VOA_BASE_URL . "?day=watchlist&all=1" );
	die;
}



if( !isset($_GET['range']) || !isset($_GET['day']) ) {
	#header("location:" . (String)$URL);
	#die;
	$_GET['range'] = "day";
	$_GET['day'] = date("Y-m-d");
}

// is start > end?
if( isset($_GET['until']) ) {

	$a = strtotime($_GET['day']);
	$b = strtotime($_GET['until']);

	if( $a > $b ) {
		$URL->set("until", date("Y-m-d", $a));
		$URL->set("day", date("Y-m-d", $b));

		header("location:" . (String)$URL);
		die;
	}
}

if(
	isset($_GET['all']) === false &&
	isset($_GET['more']) === false &&
	isset($_GET['show']) === false
) {
	#$URL->set("show", "regions");
	$_GET['show'] = "regions";
	#header("location:" . (String)$URL);
	#die;
}

# ============================================================================
# calendar navigation / general queries
# ============================================================================

# $range_day = $_GET['day'];
$range_day = $_GET['day'];
if( isset( $_GET['keywords']) ) {
	$matches = preg_match( "/date:([0-9|\-]+)/", $_GET['keywords'], $m );
	if( $matches == 1 && is_array($m) && isset( $m[1] ) ) {
		$range_day = $m[1];
	} else {
		$range_day = date("Y-m-d");
	}
} else {
	$range_day = date("Y-m-d");
}

$RANGE = new Insights_Range(
	$range_day,
	(isset($_GET['day']) ? $_GET['day'] : null),
	(isset($_GET['until']) ? $_GET['until'] : null)
);
$RANGE->active = $RANGE->{$_GET['range']};
$smarty->assign( 'range', $RANGE );
#pre($RANGE);

# ============================================================================
# ajax / post mode?
# ============================================================================
if( isset( $_GET['delete'] ) ) {
	insights_action_delete();
}

if( isset( $_POST ) && isset( $_POST['form_type'] ) ) {
	insights_action_add_update();
}

# ============================================================================
# assume view mode: provide common queries, entries and activity
# ============================================================================

$queries = insights_get_common_queries();

foreach( $queries as $query => $data ) {
	$smarty->assign( $query, $data );
}

# hint entries for calendar (activity level)
$smarty->assign( 'activity', insights_activity() );


# ============================================================================
# query routine
# ============================================================================
$query_entries = array(
	"deleted" => "No",
	"from" => $RANGE->active->range_start_human,
	"to" => $RANGE->active->range_end_human
);

// hold for release -- deadline = null
if( isset( $_GET['day'] ) && $_GET['day'] === 'HFR' ) {
	$query_entries["HFR"] = true;
}

// watchlist -- cookie based
if( isset( $_GET['day'] ) && $_GET['day'] === 'watchlist' ) {
	$watchlist = insights_get_watchlist();
	unset($query_entries["from"]);
	unset($query_entries["to"]);
	$query_entries["id"] = $watchlist;

	// note when an entry is deleted in a watchlist
	unset($query_entries["deleted"]);

	$smarty->assign( "watchlist", $watchlist );
}

# ============================================================================
# default behavior is now a search
# ============================================================================
if( isset( $_GET['day']) && $_GET['day'] == "watchlist" ) {
	// ...
} else {

	if( isset( $_GET['keywords']) ) {
		// good...
	} else {
		# $_GET['keywords'] = "date:" . $RANGE->active->range_start_human;
		$_GET['search'] = "Search";
	}

	include( "index_search.php" );
}

# override: admin mode - requests particular ids
if( isset( $_GET['term_type']) && isset( $_GET['term_id']) ) {

	# reset query, ignoring date ranges, etc
	$query_entries = array();

	# make sure we only allow presets
	if( in_array($_GET['term_type'], $ALLOW_TYPE ) === false ) {
		die( "error: term type not allowed");
	}

	# find a list of entry ids associated with term type / term id
	$tbl = TABLE_PREFIX;

	$entry_ids_from_map = $db->Index("entry_id")->Query(
		"select * from `{$tbl}map` where `type`=? and `other_id`=? and `is_deleted`='No'",
		array(
			$_GET['term_type'],
			intval($_GET['term_id'])
		)
	);

	$query_entries["id"] = array_keys( $entry_ids_from_map );
}

// exception for edit mode
if( !isset( $_GET['edit']) ) {
	$entries = insights_get_entries($query_entries);
	$all_maps = insights_get_all_maps( $entries );
} else {
	$entries = array();
	$all_maps = array( "all_maps" => array(), "empty" => array() );
}


# perform filtration by-group
# 		entries contains entire list
#			we only want entries organized by
#			[beats, divisions, editors, mediums, regions]
if( isset( $_GET['show'] ) ) {
	$grouped_entries = insights_group_by( $_GET['show'], $entries );
	$smarty->assign( 'grouped_entries', $grouped_entries );
}

/*echo "<PRE style='background-color:gainsboro; padding:10px'>";
print_r($query_entries);

die;
echo count($entries) . "<br/>";
echo count($all_maps["all_maps"]) . "<br/>";
print_r( $all_maps );
print_r( $entries );
//print_r( $grouped_entries ); // for show mode only
die;
*/
$smarty->assign( 'all_maps', $all_maps["all_maps"] );
$smarty->assign( 'all_maps_empty', $all_maps["empty"] );
$smarty->assign( 'entries', $entries );
