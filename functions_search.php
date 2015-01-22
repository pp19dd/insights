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
        "words" => array(),     // simple string
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
            }
        } else {
            $ret["all"][] = insights_escape_word($word);
        }
    }

    return( $ret );
}

// quotes break syntax
function insights_escape_word($w) {
    return( str_replace('"', '', $w) );
}

function insights_build_es_query($search) {

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

            default:
                pre($search);
                break;
        }
    }

    $query = '
    {
        "size": 100,
        "query": {
            "bool": {
                "must": [
                    ' . implode(",", $matches) . '
                ]
            }
        },
        "sort": { "deadline": "desc" }
    }
    ';
    return( $query );
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
