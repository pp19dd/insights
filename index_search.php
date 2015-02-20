<?php
if( !defined("INSIGHTS_RUNNING") ) die("Error 211.");

# ============================================================================
# search is now specialized: ElasticSearch
# ============================================================================

$search = insights_parse_search_words( $_GET['keywords'] );

// pagination hints
if( !isset( $_GET['p']) ) {
	$page = 1;
} else {
	$page = intval( $_GET['p'] );
}
$pages = insights_search_pagination($page);

// elastic search mode
$search_results = array(
	"exact" => array( "hits" => array("total" => 0), "total" => ""),
	"fuzzy" => array( "hits" => array("total" => 0), "total" => "")
);

try {
	$search_results["exact"] = $ELASTIC->Query(
		insights_build_es_query($search, $pages["from"])
	);
} catch( Exception $e ) {
	// :(
}

// given # of results, compute # of available pages
$result_count = $search_results["exact"]["hits"]["total"];

$pages["page_count"] = ceil($result_count / PER_PAGE);
for( $i = 0; $i < $pages["page_count"]; $i++ ) {
	$pages["pages"][] = $i + 1;
}

/*
pagination for > 15 pages:

[part a] [...] [part b] [...] [part c]
*/
/*
if( count($pages["pages"]) > 15 ) {
	$page_width = 6;
	$halfpage_width = 3;

	$pages_a = array_slice($pages["pages"], 0, $page_width);
	$pages_b = array_slice($pages["pages"], $pages["current"] - $halfpage_width-1, $halfpage_width*2);
	$pages_c = array_slice($pages["pages"], -$page_width);

	$pages_delim = array("...");

	$pages["pages"] = array();
	$pages["pages"] = array_merge($pages["pages"], $pages_a);
	$pages["pages"] = array_merge($pages["pages"], $pages_delim);
	$pages["pages"] = array_merge($pages["pages"], $pages_b);
	$pages["pages"] = array_merge($pages["pages"], $pages_delim);
	$pages["pages"] = array_merge($pages["pages"], $pages_c);

	#die;
}
*/
$smarty->assign( "pages", $pages);

// ===========================================================================
// elastic search worked, but, still doing classic query for data display
// in form of ids; ex: ( [id] => Array ( [0] => 11035 ) )
// ===========================================================================
$query_entries = array();
$query_entries["id"] = array();
$query_entries["orderby"] = "deadline";
$query_entries["direction"] = "desc";
if( $result_count === 0 ) $query_entries["stop"] = true;

// combine two separate searches into one result
process_elastic_ids($search_results["exact"], $query_entries["id"]);
process_elastic_ids($search_results["fuzzy"], $query_entries["id"]);

# $smarty->assign( "search_tips", $search["words"]);
$smarty->assign( "search_tips", insights_search_tips($search["words"]));
$smarty->assign( "highlight", $search );

$smarty->assign( "elasticsearch_results", $search_results );
