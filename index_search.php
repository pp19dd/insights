<?php
if( !defined("INSIGHTS_RUNNING") ) die("Error 211.");

# ============================================================================
# search is now specialized: ElasticSearch
# ============================================================================


$words = explode(" ", trim(strip_tags($_GET['keywords'])));
$words = array_filter( $words );

if( count($words) == 0 ) {
	$query_entries["stop"] = array("Warning: Empty search string");
} else {
	$query_entries["search"] = $words;
}

// search removal tips
$tips = array();
foreach( $words as $word ) {
	$words_as_keys = array_flip( $words );
	unset( $words_as_keys[$word]);
	$tips[$word] = implode(" ", array_keys($words_as_keys));
}
$VOA->assign( "search_tips", $tips);

// elastic search mode
$search_results = array(
	"exact"	=> array(),
	"fuzzy" => array()
);

/*
{
    "query": {
        "bool": {
            "should": [
                { "match": { "slug": { "query": "pkg", "operator": "and" } }},
                { "match": { "description": { "query": "pkg", "operator": "and" } }}
            ]
        }
    }
}
*/

$search_words = implode(" ", $words);
$search_results["exact"] = $ELASTIC->Query('
{
    "query": {
        "dis_max": {
            "queries": [
                { "match": { "slug": { "query": "'.$search_words.'", "operator": "and" } }},
                { "match": { "description": { "query": "'.$search_words.'", "operator": "and" } }}
            ]
        }
    }
}
');
$search_results["fuzzy"] = $ELASTIC->Query('
{
    "query": {
        "dis_max": {
            "queries": [
                { "fuzzy": { "slug": "'.$search_words.'" }},
				{ "fuzzy": { "description": "'.$search_words.'" }}
            ]
        }
    }
}
');

/*
$search_results["exact"] = $ELASTIC->Query('
{
	"query": {
		"bool": {
			"should": [
				{
					"match": {
						"slug": {
							"query": "'.$search_words.'",
							"operator": "and"
						}
					}
				},
				{
					"match": {
						"description": {
							"query": "'.$search_words.'",
							"operator": "and"
						}
					}
				}
			]
		}
	}
}
');

$search_results["fuzzy"] = $ELASTIC->Query('
{
	"query": {
		"bool": {
			"should": [
				{
					"fuzzy": {
						"slug": "'.$search_words.'"
					}
				},
				{
					"fuzzy": {
						"description": "'.$search_words.'"
					}
				}
			]
		}
	}
}
');
*/

// append search results ids to query
function process_elastic_ids($r, &$ids) {
	static $seen = array();

	foreach( $r["hits"]["hits"] as $hit ) {
		$id = $hit["_id"];
		if( isset( $seen["id"]) ) continue;

		$seen[$id] = true;
		$ids[] = $id;
	}
}

$query_entries = array();
$query_entries["id"] = array();
process_elastic_ids($search_results["exact"], $query_entries["id"]);
process_elastic_ids($search_results["fuzzy"], $query_entries["id"]);

#pre($query_entries);
#pre($search_results);
