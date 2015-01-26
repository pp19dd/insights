<?php

class Insights_ElasticSearch {

    public $client;
    public $batch_size = 500;

    function __construct() {

        $params = array(
            "hosts" => array(ELASTICSEARCH_HOST),
            "connectionParams" => array(
                "auth" => array(
                    ELASTICSEARCH_USER,
                    ELASTICSEARCH_PASS,
                    "Basic"
                )
            )
        );

        try {
            $this->client = new Elasticsearch\Client($params);
        } catch( Exception $e ) {
            $this->onException("construct", null, $e);
        }
    }

    // for overrides
    function onException($label, $id = null, $e) {

    }

    function Query($raw_json) {

/*
$raw_json = <<< EOF

{
    "query" : {
        "match" : {
            "slug" : "obama"
        }
    }
}

EOF;
*/
        $params = array("body" => $raw_json);

        $params["index"] = "insights";
        #$params["type"] = "entries";

        return( $this->client->search($params) );
    }

    function batchInsert($batch_number) {
        global $db;
        $tbl = TABLE_PREFIX;

        $limit_b = intval($this->batch_size);
        $limit_a = intval($batch_number) * $limit_b;

        $entries = $db->Query(
            "select `id` from `{$tbl}entries` where `is_deleted`='No' limit {$limit_a}, {$limit_b}"
        );

        $params = array("body"=>array());
        foreach( $entries as $entry ) {

            $id = $entry["id"];
            $data = $this->getEntry($id);

            $params["body"][] = array(
            	"index" => array("_id" => $id)
            );
            $params["body"][] = $data;
        }

        $params["index"] = "insights";
        $params["type"] = "entry";

        $ret = $this->client->bulk($params);

        return($entries);
    }

    function getBatchCount() {
        $count = $this->getRecordCount();
        $batches = $count / $this->batch_size;
        return( ceil($batches) );
    }

    function getRecordCount() {
        global $db;
        $tbl = TABLE_PREFIX;

        $r = $db->Single()->Query(
            "select count(id) as `entry_count` from `{$tbl}entries` where is_deleted='No'"
        );

        return( $r["entry_count"] );
    }

    function createIndex() {
        try {
            $ret = $this->client->indices()->create(array(
                "index"=>"insights"
            ));
            return( $ret );
        } catch( Exception $e ) {
            $this->onException("create_index", null, $e);
        }
    }

    function deleteIndex() {
        try {
            $ret = $this->client->indices()->delete(array(
                "index"=>"insights"
            ));
            return( $ret );
        } catch( Exception $e ) {
            $this->onException("delete_index", null, $e);
        }
    }

    function getStatus() {
        try {
            $ret = $this->client->indices()->stats(array(
                "index" => "insights"
            ));
            return($ret);
        } catch( Exception $e ) {
            $this->onException("status", null, $e);
        }
    }

    function reduceMap($map) {
        $ret = array();
        foreach( $map as $map_type => $data ) {
            if( !isset( $ret[$map_type]) ) $ret[$map_type] = array();
            foreach( $data as $map_entry ) {
                if( isset($map_entry["resolved"]["name"]) ) {
                    $ret[$map_type][] = $map_entry["resolved"]["name"];
                }
            }
        }

        # reduce further, for facets
        foreach( $ret as $k => $v ) {
            $v = str_replace(
                array(" ", ","),
                array("_", "_"),
                implode("@#@", $v)
            );
            $v = str_replace("@#@", ",", $v);
            $ret["facet_{$k}"] = $v;
        }

        #        $this->reduceMapDebug($ret,$map);

        return($ret);
    }

    function reduceMapDebug($ret, $map) {
        echo "<div style='float:right; width:50%; border-left:2px solid gray; padding:10px'>";
        pre($ret, false);
        echo "</div>";
        pre($map, false);
        die;
    }

    function getEntry($id) {
        $entries = insights_get_entries(array(
            "id" => array($id)
        ));
        $entry = $entries[$id];

        $map = $this->reduceMap($entry["map"]);

        // merge map and entry
        unset( $entry["map"] );
        foreach( $map as $k => $v ) {
            $entry["map_{$k}"] = $v;
        }

        return( $entry );
    }

    function onUpdate($id) {
        $entry = $this->getEntry($id);

        try {
            $ret = $this->client->index(array(
                "id" => $id,
                "body" => $entry,
                "index" => "insights",
                "type" => "entry"
            ));
        } catch( Exception $e ) {
            $this->onException("update", $id, $e);
        }
    }

    function onDelete($id) {
        try {
            $ret = $this->client->delete(array(
                "id" => $id,
                "index" => "insights",
                "type" => "entry"
            ));
        } catch( Exception $e ) {
            $this->onException("delete", $id, $e);
        }
    }

}
