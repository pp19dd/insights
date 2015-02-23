<?php
if( !defined("INSIGHTS_RUNNING") ) die("Error 211.");

/**
* breaks up search string into a complex structure
* array of (type / word) pairs.  type = _all or field name
* field names that are accepted
*       slug        description
*       origin      medium      beat        region      reporter    editor
*
* example return:
* Array (
*     [words] => Array(
*         [0] => obama
*         [1] => pkg
*         [2] => editor:jim
*     )
*     [highlight] => Array(
*         [0] => obama
*         [1] => pkg
*         [2] => jim
*     )
*     [all] => Array(
*         [0] => obama
*         [1] => pkg
*     )
*     [complex] => Array(
*         [0] => Array(
*             [type] => editor
*             [word] => jim
*         )
*     )
* )

*/

function insights_parse_search_words( $keywords ) {

    $ret = array(
        "words" => array(),     // simple string, raw
        "highlight" => array(), // simple string, stripped of prefixes
        "all" => array(),       // _all
        "complex" => array()    // specialized fields
    );

    // input: "obama    pkg editor:jim"
    $words = explode(" ", trim(strip_tags( $keywords)));

    // get rid of empty elements
    $words = array_filter( $words );

    // check for "prefix:"
    foreach( $words as $word ) {

        $ret["words"][] = $word;

        // "editor:jim:extra"
        if( stripos($word, ":") !== false ) {
            $m = preg_match("/(.*?):(.*)/", $word, $r);
            if( count($r) === 3 ) {
                $ret["complex"][] = array(
                    "type" => $r[1], // editor
                    "word" => insights_escape_word($r[2])  // jim
                );
                $ret["highlight"][] = insights_escape_word($r[2]);
            }
        } else {
            $ret["all"][] = insights_escape_word($word);
            $ret["highlight"][] = insights_escape_word($word);
        }
    }

    return( $ret );
}

// quotes break syntax
function insights_escape_word($w) {
    return( str_replace('"', '', $w) );
}

function insights_build_es_query($search, $from = 0, $per_page = PER_PAGE) {

    $matches = array();
    if( !empty($search["all"]) ) {
        $search_words = implode(" ", $search["all"]);
        $matches[] = '{ "match": { "_all": { "query": "' . $search_words . '", "operator": "and" } } }';
    }

    foreach( $search["complex"] as $f ) {
        switch( $f["type"] ) {
            case 'editor':
                $matches[] = '{ "match": { "map_editors": { "query": "' . $f["word"] . '", "operator": "and" } } }';
                break;

            case 'reporter':
                $matches[] = '{ "match": { "map_reporters": { "query": "' . $f["word"] . '", "operator": "and" } } }';
                break;

            case 'region':
                $matches[] = '{ "match": { "map_regions": { "query": "' . $f["word"] . '", "operator": "and" } } }';
                break;

            case 'beat':
                $matches[] = '{ "match": { "map_beats": { "query": "' . $f["word"] . '", "operator": "and" } } }';
                break;

            case 'medium':
                $matches[] = '{ "match": { "map_mediums": { "query": "' . $f["word"] . '", "operator": "and" } } }';
                break;

            case 'origin':
                $matches[] = '{ "match": { "map_services": { "query": "' . $f["word"] . '", "operator": "and" } } }';
                break;

            case 'date':
                $matches[] = '{ "match": { "deadline": { "query": "' . $f["word"] . '", "operator": "and" } } }';
                #pre($f);
                break;

            default:
                ####pre($search);
                break;
        }
    }

    $query = '
    {
        "size": ' . $per_page . ',
        "from": ' . $from . ',
        "query": {
            "bool": {
                "must": [
                    ' . implode(",", $matches) . '
                ]
            }
        },
        "sort": [
            { "deadline_dt": { "order": "desc" } }
        ],
        "aggregations": {
            "reporters": { "terms": { "field": "facet_reporters" , "size": 500} },
            "beats": { "terms": { "field": "facet_beats" , "size": 500} },
            "editors": { "terms": { "field": "facet_editors" , "size": 500} },
            "divisions": { "terms": { "field": "facet_divisions" , "size": 500} },
            "services": { "terms": { "field": "facet_services" , "size": 500} },
            "mediums": { "terms": { "field": "facet_mediums" , "size": 500} },
            "regions": { "terms": { "field": "facet_regions", "size": 500 } }
        }
    }
    ';

# "facets": {
#     "map_reporters": { "terms": { "field": "map_reporters" } },
#     "map_editors": { "terms": { "field": "map_editors" } },
#     "map_medium": { "terms": { "field": "map_medium" } }
# }

    return( $query );
}

// pagination helper: based on a total count and current page,
// give us number of pages and current record range
function insights_search_pagination($page) {
    if( $page < 0 ) $page = 0;
    $a = array(
        "current" => $page,
        "from" => ($page - 1) * PER_PAGE,
        "pages" => array()
    );
    return($a);
}

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

// search removal tips: each word includes all but itself
function insights_search_tips($words) {

    $tips = array();
    foreach( $words as $word ) {
    	$words_as_keys = array_flip( $words );
    	unset( $words_as_keys[$word]);
    	$tips[$word] = implode(" ", array_keys($words_as_keys));
    }
    return( $tips );

}
