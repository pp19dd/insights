<?php

class Insights_ElasticSearch {

    public $client;

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
