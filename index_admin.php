<?php
if( !defined("INSIGHTS_RUNNING") ) die("Error 211.");

#$ELASTIC->batchInsert(0); die;
#$x = $ELASTIC->query("x");print_r( $x ); die;

# ============================================================================
# ajax mode, control panel
# ============================================================================
if( isset( $_POST['ajax']) && isset( $_POST['action'] ) ) {

    $ret = array("html2" => "");
    switch( $_POST['action'] ) {
        case 'elasticsearch_records':
            $ret["html"] = "Entry count: " . $ELASTIC->getRecordCount();
        break;

        case 'elasticsearch_query':
            try {
                $results = $ELASTIC->Query($_POST['option']);

                switch( $_POST['format'] ) {
                	case 'print_r':
                	    $ret["html"] = "<PRE>" . print_r($results, true) . "</PRE>";
                	break;

                	case 'print_r | hits':
                	    $ret["html"] = "<PRE>" . print_r($results["hits"]["hits"], true) . "</PRE>";
                	break;

                	case 'print_r | facets':
                	    $ret["html"] = "<PRE>" . print_r($results["facets"], true) . "</PRE>";
                	break;

                	case 'table':
                        $ret["html2"] = sprintf(
                            "Total: <strong>%s</strong><br/>" .
                            "Max Score: <strong>%s</strong><br/>",
                            $results["hits"]["total"],
                            $results["hits"]["max_score"]
                        );
                    //print_r($results["hits"]["hits"], true);

                	    $ret["html"] = "<table class='elasticsearch_table_results'>";
                	    foreach( $results["hits"]["hits"] as $hit ) {
                	        $ret["html"] .= sprintf(
                                "<tr>" . str_repeat("<td>%s</td>", 4) . "</tr>",
                	            $hit["_source"]["id"],
                	            $hit["_source"]["deadline"],
              	                $hit["_source"]["slug"],
              	                $hit["_source"]["description"]
                	        );
                	    }
                	    $ret["html"] .= "</table>";
                	break;

                	case 'console':
                	    $ret["html"] = "View console for output.";
                	    $ret["debug"] = $results;
                	break;
                }

            } catch( Exception $e ) {
                $ret["html"] = print_r( $e->getMessage(), true );
            }

            break;

        case 'elasticsearch_status':
            $status = $ELASTIC->getStatus();
            $docs = $status["indices"]["insights"]["total"]["docs"];

            if( is_null($docs) ) {
                $ret["html"] = "Error: can't query status. Is an index created?";
            } else {
                $ret["html"] = "Indexed records: " . $docs["count"] . ", deleted records: " . $docs["deleted"];
            }
        break;

        case 'elasticsearch_create_index':
            $ack = $ELASTIC->createIndex();
            if( isset($ack["acknowledged"]) && $ack["acknowledged"] == 1 ) {
                $ret["html"] = "Index created. Please make sure to bulk insert ASAP.";
            } else {
                $ret["html"] = "Error: did not create index?";
            }
            break;

        case 'elasticsearch_delete_index':
            $ack = $ELASTIC->deleteIndex();
            if( isset($ack["acknowledged"]) && $ack["acknowledged"] == 1 ) {
                $ret["html"] = "Index deleted. Please make sure to recreate it ASAP.";
            } else {
                $ret["html"] = "Error: did not delete index?";
            }
        break;

        case 'elasticsearch_bulk_insert':
            // insertion could take awhile
            set_time_limit(180);

            $ret["html"] = "";
            $batch_html = "<div class='elastic_batches'>";
            for( $i = 0; $i < $ELASTIC->getBatchCount(); $i++ ) {
                $batch_html .= "<div class='batch batch_{$i}'>{$i}</div>";
            }
            $batch_html .= "</div>";
            $ret["html"] .= $batch_html;
            $ret["command"] = "next";
            $ret["index"] = 0;
            //usleep(100000);
        break;

        case 'elasticsearch_bulk_insert_batch':
            // insertion could take awhile
            set_time_limit(180);

            $batches = $ELASTIC->getBatchCount();
            $index = intval($_POST['option']['index']);
            $finish = $batches - 1;

            // do elastic bulk insert
            $x = $ELASTIC->batchInsert($index);

            // signal completion
            $ret["done"] = $index;

            if( $index >= $finish ) {
                // done - verify?
            } else {
                $ret["command"] = "next";
                $ret["index"] = $index + 1;
            }
        break;

        case 'rename':

            $term_id = intval($_POST['term_id']);
            $term_name = trim(strip_tags($_POST['term_name']));
            $term_type = $_POST['term_type'];

            # for this safety filter, try_type is cooerced into an array
            global $ALLOW_TYPE;
            $tbl = TABLE_PREFIX;
            $type = array_intersect($ALLOW_TYPE, array($term_type) );
            if( empty( $type ) ) {
                die( "Error: term type not allowed");
            }
            $type = array_shift( $type );

            $VOA->query(
                "update `{$tbl}{$type}` set `name`='%s' where `id`=%s limit 1",
                $term_name,
                $term_id
            );
            $ret["status"] = "good";
            $ret["term_name"] = $term_name;
            $ret["term_id"] = $term_id;
        break;

        case 'merge':

            # make sure term ids exist
            if(
                !isset( $_POST['terms_to_merge']) ||
                !is_array( $_POST['terms_to_merge']) ||
                empty( $_POST['terms_to_merge']))
            {
                die( "Error: terms not listed/specified");
            }
            $terms = array();
            foreach( $_POST['terms_to_merge'] as $term ) {
                $terms[] = intval( $term );
            }

            # for this safety filter, try_type is cooerced into an array
            $term_type = $_POST['term_type'];
            global $ALLOW_TYPE;
            $tbl = TABLE_PREFIX;
            $type = array_intersect($ALLOW_TYPE, array($term_type) );
            if( empty( $type ) ) {
                die( "Error: term type not allowed");
            }
            $type = array_shift( $type );

            # simple int
            $reassign_to = intval( $_POST['reassign_to'] );

            # do the merge
             $VOA->query(
                 "update `{$tbl}map` set `other_id`=%s where `other_id` in (%s) and `type`='%s' and `is_deleted`='No'",
                $reassign_to,
                implode(",", $terms),
                $type
             );

            $ret["status"] = "good";
        break;

    }

    echo json_encode($ret);
    die;
}

# ============================================================================
# admin-related queries
# ============================================================================
$queries = insights_get_common_queries();

foreach( $queries as $query => $data ) {
    $VOA->assign( $query, $data );
}
