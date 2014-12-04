<?php
include_once( "vendor/autoload.php");

class Insights_ElasticSearch {

    public $client;

    function __construct() {
        try {
            $this->client = new Elasticsearch\Client(array(
                "hosts" => array(ELASTICSEARCH_HOST)
            ));
        } catch( Exception $e ) {
            // hrmmrm
        }
    }

    function getEntry($id) {
        $entry = insights_get_entries(array(
            "id" => array($id)
        ));
        return( $entry );
    }

    function onUpdate($id) {
        $entry_array = $this->getEntry($id);
        $entry = $entry_array[$id];

        try {
            $ret = $this->client->index(array(
            "id" => $id,
            "body" => $entry,
            "index" => "insights",
            "type" => "entry"
            ));
        } catch( Exception $e ) {
            // hmmmm
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
            // hrmm
        }
    }

}
