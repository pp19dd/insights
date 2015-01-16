<?php
if( !defined("INSIGHTS_RUNNING") ) die("Error 211.");

# ============================================================================
# search is now specialized: ElasticSearch
# ============================================================================

$words = explode(" ", trim(strip_tags($_GET['keywords'])));
$words = array_filter( $words );

/*
if( count($words) == 0 ) {
	$query_entries["stop"] = array("Warning: Empty search string");
} else {
	$query_entries["search"] = $words;
}
*/

// search removal tips
$tips = array();
foreach( $words as $word ) {
	$words_as_keys = array_flip( $words );
	unset( $words_as_keys[$word]);
	$tips[$word] = implode(" ", array_keys($words_as_keys));
}
$smarty->assign( "search_tips", $tips);

// elastic search mode
$search_results = array(
	"exact"	=> array(),
	"fuzzy" => array()
);

$search_words = implode(" ", $words);
$search_results["exact"] = $ELASTIC->Query('
{
	"size": 100,
	"query": {
		"match": {
			"_all": { "query": "' . $search_words . '", "operator": "and" }
		}
	},
	"sort": { "deadline": "desc" }
}
');

// append search results ids to query
function process_elastic_ids($r, &$ids) {
	static $seen = array();

	if(
		!isset( $r["hits"]) ||
		!isset( $r["hits"]["hits"] )
	) {
		return(false);
	}

	foreach( $r["hits"]["hits"] as $hit ) {
		$id = $hit["_id"];
		if( isset( $seen["id"]) ) continue;

		$seen[$id] = true;
		$ids[] = $id;
	}
}

// elastic search worked, but, still doing classic query for data display
// in form of ids; ex: ( [id] => Array ( [0] => 11035 ) )
$query_entries = array();
$query_entries["id"] = array();
$query_entries["orderby"] = "deadline";
$query_entries["direction"] = "desc";

process_elastic_ids($search_results["exact"], $query_entries["id"]);
process_elastic_ids($search_results["fuzzy"], $query_entries["id"]);
$smarty->assign( "elasticsearch_results", $search_results );

#echo "<PRE>"; print_r($query_entries);die;
#echo "<PRE>"; print_r($search_results);die;
