<?php
if( !defined("INSIGHTS_RUNNING") ) die("Error 211.");

# ============================================================================
# search is now specialized: ElasticSearch
# ============================================================================

$search = insights_parse_search_words( $_GET['keywords'] );


// elastic search mode
$search_results = array(
	"exact"	=> $ELASTIC->Query(insights_build_es_query($search)),
	"fuzzy" => array()
);

// ===========================================================================
// elastic search worked, but, still doing classic query for data display
// in form of ids; ex: ( [id] => Array ( [0] => 11035 ) )
// ===========================================================================
$query_entries = array();
$query_entries["id"] = array();
$query_entries["orderby"] = "deadline";
$query_entries["direction"] = "desc";

process_elastic_ids($search_results["exact"], $query_entries["id"]);
process_elastic_ids($search_results["fuzzy"], $query_entries["id"]);

# $smarty->assign( "search_tips", $search["words"]);
$smarty->assign( "search_tips", insights_search_tips($search["words"]));

$smarty->assign( "elasticsearch_results", $search_results );
