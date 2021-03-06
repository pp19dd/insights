<?php
if( !defined("INSIGHTS_RUNNING") ) die("Error 211.");


/**
 * adds metadata for an entry
 *
 * @param $try_type String partial table name (ex: reporters, editors, beats)
 * @param $entry_id Integer entries.id
 * @param $action_id Integer _history.id
 * @param $other_ids Integer associates existing meta entry
 * @param $other_ids String  adds new meta entry, associates
 * @param $other_ids Array  can contain integer / string combinations
 * @param $ret Array This function doesn't return, but inserts added associated meta info to this parameter
 * @param $add_new_entry boolean True/False - beats are hardcoded, but editors and reporters might get added
 */

function insights_add_map( $try_type, $entry_id, $action_id, $other_ids, &$ret, $add_new_entry = true ) {
    global $db;
    global $ALLOW_TYPE;

    # for this safety filter, try_type is cooerced into an array
    $tbl = TABLE_PREFIX;
    $type = array_intersect($ALLOW_TYPE, array($try_type) );

    # should be only one
    $type = array_shift( $type );

    if( !is_array($other_ids) ) {
        $other_ids = array( $other_ids );
    }

    foreach( $other_ids as $other_id ) {

        // add entry to originating table

        // empty entry, skip
        if( strlen(trim($other_id)) == 0 ) continue;

        if( !is_numeric( $other_id ) ) {

            // skip adding entry since there is no matched value
            if( $add_new_entry !== true ) continue;

            $db->Query(
                "insert into `{$tbl}{$type}` (`name`) values (?)",
                $other_id
            );

            $other_id = $db->getInsertID();

            if( is_array( $ret ) ) {
                if( !isset( $ret['other'][$type] ) ) $ret['other'][$type] = array();
                $ret['other'][$type][] = $other_id;
            }

        }

        $db->Query(
            "insert into `{$tbl}map`
                (`action_id`, `type`, `entry_id`, `other_id`)
            values
                (:action_id, :type, :entry_id, :other_id)",
            array(
                ":action_id" => intval( $action_id ),
                ":type" => $type,
                ":entry_id" => intval( $entry_id ),
                ":other_id" => intval( $other_id )
            )
        );

        $map_id = $db->getInsertID();

        if( is_array( $ret ) ) {
            if( !isset( $ret['map'][$type] ) ) {
                $ret['map'][$type] = array();
            }

            $ret['map'][$type][] = $map_id;
        }
    }
}

/**
 * marks an entry deleted (is_deleted becomes Yes)
 */
function insights_delete_entry( $entry_id ) {
    global $db;
    global $ELASTIC;

    $tbl = TABLE_PREFIX;

    insights_history($entry_id, "delete");

    $db->Query(
        "update `{$tbl}entries` set `is_deleted`='Yes' where `id`=? limit 1",
        intval( $entry_id )
    );

    $ELASTIC->onDelete($entry_id);
}

/**
 * marks an entry starred/unstarred (is_starred becomes Yes or No)
 */
function insights_star( $entry_id, $star = 'Yes' ) {
    global $db;
    $tbl = TABLE_PREFIX;

    insights_history($entry_id, "star", $star);

    $db->Query(
        "update `{$tbl}entries` set `is_starred`=? where `id`=? limit 1",
        array( $star, intval( $entry_id ) )
    );
}

/**
 * when updating entries, delete old metadata (mark is_deleted to Yes)
 *
 * @param $entry_id entries.id
 */
function insights_clear_map( $entry_id ) {
    global $db;
    $tbl = TABLE_PREFIX;

    $db->query(
        "update `{$tbl}map` set `is_deleted`='Yes' where `entry_id`=?",
        intval( $entry_id )
    );
}

/**
 * returns only the hour-resembling portion of a string
 * @param string $time ex: "text 04:00 text"
 * @return boolean|string ex: false or "04:00"
 */
function insights_filter_time( $time ) {
	$try = preg_match( "/([0-9|:]+)/", $time, $r );
	if( $try === false ) return( false );
	if( empty($try) ) return( false );

	return( $r[0] );
}

/**
 * returns only the date-resembling portion of a string
 * @param string $date ex: "text 2014-03-02 text"
 * @return boolean|string ex: false or "2014-03-02"
 */
function insights_filter_date( $date ) {
	$try = preg_match( "/([0-9|-]+)/", $date, $r );
	if( $try === false ) return( false );
	if( empty($try) ) return( false );

	return( $r[0] );
}


/**
 * adds a new entry, returns an array of entries (and meta)
 *
 * @param $p Array contains $_POST parameters (slug, description, deadline, etc)
 * @param $requesting_entry_id Integer If set to -1, add a new entry. Otherwise update.
 */
function insights_add_insight( $p, $requesting_entry_id = -1 ) {
    global $db;
    global $ALLOW_TYPE;
    global $ELASTIC;

    // implied date is "today"
    if( strlen(trim($p['deadline'])) == 0 ) {
        $p['deadline'] = date("Y-m-d");
    }

    // ensure anticipated map types are at least blank
    foreach( $ALLOW_TYPE as $t ) {
        if( !isset($p[$t])) $p[$t] = array();
    }

    $ret = array(
        "entries" => array(),
        "other" => array(),
        "map" => array()
    );

    $tbl = TABLE_PREFIX;

    if( $requesting_entry_id === -1 ) {

        // two separate actions when adding an entry
        // a blank add, and an update
        $db->Query(
            "insert into `{$tbl}entries` (id) values (null)"
        );
        $entry_id = $db->getInsertID();

        // snag an action id for later notes
        $action_id = insights_history($entry_id, "add", "", true);

    } else {

        // update only
        $entry_id = intval( $requesting_entry_id );

    	// snag an action id for later notes
    	$action_id = insights_history($entry_id, "update");
    }


    // sanitized time string - can be either null or a value in db
    $time_string = "null";
    $deadline_dt = "00:00:00";
    $time = insights_filter_time( $p["deadline_time"] );
    if( $time !== false ) {
    	$time_string = "'{$time}'";
        $deadline_dt = $time;
    }

    $deadline_dt_string = sprintf(
        "%s %s",
        date("Y-m-d", strtotime($p['deadline'])),
        $deadline_dt
    );

    $db->Query(
        "update
            `{$tbl}entries`
        set
            `is_deleted`='No',
            `slug`=:slug,
            `description`=:description,
            `camera_assigned`=:camera,
            `deadline`=:deadline,
            `deadline_time`={$time_string}
        where
            `id`=:entry_id
        limit 1",
        array(
            ":slug" => trim(strip_tags($p['slug'])),
            ":description" => trim(strip_tags($p['description'])),
            ":camera" => (isset($p["camera_assigned"]) ? 'Yes' : 'No' ),
            ":deadline" => date("Y-m-d", strtotime($p['deadline'])),
            ":entry_id" => $entry_id
        )
    );

    if( isset( $p['hold_for_release']) ) {
    	$db->Query(
    		"update
    			`{$tbl}entries`
    		set
    			`deadline`=NULL
   			where
    			`id`=?
   			limit 1",
        	$entry_id
		);
	}

    $ret["entries"][] = $entry_id;

    insights_clear_map( $entry_id );

    #                 table                                                                     insert new entry?
    insights_add_map( 'reporters',	$entry_id, $action_id, explode(";", $p['reporters']), $ret, true );
    insights_add_map( 'editors',	$entry_id, $action_id, explode(";", $p['editors']),   $ret, true );

    insights_add_map( 'beats',  	$entry_id, $action_id, $p['beats'],                   $ret, false );
    insights_add_map( 'mediums',    $entry_id, $action_id, $p['mediums'],                 $ret, false );

    insights_add_map( 'regions',    $entry_id, $action_id, $p['regions'],                 $ret, false );

    // lookup table
    $services = insights_get_type( "services" );

    if( isset( $p['origin']) && isset($services[$p['origin']]) ) {
        $division_id = intval($services[$p['origin']]['division_id']);

        insights_add_map( 'divisions',    $entry_id, $action_id, $division_id,            $ret, false );
        insights_add_map( 'services',     $entry_id, $action_id, $p['origin'],            $ret, false );
    }

    $ELASTIC->onUpdate($entry_id);

    return( $ret );
}
