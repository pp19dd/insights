<?php
if( !defined("INSIGHTS_RUNNING") ) die("Error 211.");

require( "simplediff.php" );

/**
 * makes a backup of an entry, returns copy id
 */
function insights_backup($entry_id) {
    global $db;
    $tbl = TABLE_PREFIX;

    # old entry, before changing
    $old = $db->Single()->Query(
        "select * from `{$tbl}entries` where `id`=? limit 1",
        intval($entry_id)
    );

    # insert a copy, as a deleted entry
    unset( $old["id"] );
    unset( $old["last_update"] );
    $keys = array();
    $values = array();
    $old["is_deleted"] = "Yes";

    # sanitize
    foreach( $old as $k => $v ) {
        $keys[] = mysql_real_escape_string($k);
        $values[] = mysql_real_escape_string($v);
    }
    $keys = implode("`, `", $keys);
    $values = implode("', '", $values);

    # this routine normally sanitizes parameters, bypass it with our own
    $db->Query(
        "insert into `{$tbl}entries` (`{$keys}`) values ('{$values}');"
    );
    $copy_id = $db->getInsertID();

    return( $copy_id );
}

/**
 * stores change information, copies original entry as a deleted item
 *
 *  @param $entry_id integer entries.id
 *  @param $action String (add, update, delete, star)
 *  @param $note String optional note (ex: function parameter)
 *  @return integer Action ID (newly inserted into __history)
 */

function insights_history( $entry_id, $action, $note = '', $skip_copy = false ) {
    global $db;
    $tbl = TABLE_PREFIX;

    # phase one: make copies of all data associated with this $action_id
    if( $action === 'update' && $skip_copy === false ) {
        $copy_id = insights_backup($entry_id);

        # override $note to point to the old entry
        $note = "~" . $copy_id;
    }

    # phase two: get action id, record info about user and action
    $db->Query(
        "insert into `{$tbl}_history`
            (`ip`, `action`, `entry_id`, `note`)
        values
            (:addr, :action, :entry_id, :note)",
        array(
            ":addr" => $_SERVER["REMOTE_ADDR"],
            ":action" => $action,
            ":entry_id" => intval( $entry_id ),
            ":note" => $note
        )
    );

    $action_id = $db->getInsertID();

    return( $action_id );
}

/**
 * given a detailed map array, returns a simple english version
 */
function insights_simplified_map( $map ) {
    $s = array();

    # first pass, collect data
    foreach( $map as $k => $v ) {
        if( !isset($s[$v['type']]) ) $s[$v['type']] = array();
        $s[$v['type']][] = $v['resolved']['name'];
    }
    ksort( $s );

    # second pass, sort sub-keys
    foreach( $s as $k => $v ) {
        ksort( $s[$k] );
    }

    # third pass, implode to a simple string
    foreach( $s as $k => $v ) {
        $s[$k] = implode(", ", $v);
    }

    return( $s );
}

/**
 * returns all known information about an item
 */
function insights_get_history( $entry_id ) {
    global $db;
    $tbl = TABLE_PREFIX;

    $r = array();
    $r['history'] = $db->Query(
        "select * from `{$tbl}_history` where `entry_id`=? order by `id` desc",
        $entry_id
    );

    foreach( $r['history'] as $k => $v ) {

        # if this is an update, get copy of older version entry
        if( $v['action'] === 'update' && substr($v['note'], 0, 1) === '~' ) {
            $old_entry_id = intval(substr( $v['note'], 1 ));

            $r['history'][$k]['entry'] = $db->Single()->Query(
                "select * from `{$tbl}entries` where `id`=? limit 1",
                $old_entry_id
            );
        }

        # find map for entry
        $r['history'][$k]['map'] = $db->Query(
            "select * from `{$tbl}map` where `action_id`=? order by `id` asc",
            $v["id"]
        );

        $resolved = array();

        # assume that is_deleted will match
        foreach( $r['history'][$k]['map'] as $k2 => $map ) {
            $map = resolve_map(
                $map["type"],
                $map["other_id"],
                "No"
            );

            $r['history'][$k]['map'][$k2]['resolved'] = $map;
        }

        # make a simple list for a text-based diff
        $r['history'][$k]['simple'] = insights_simplified_map( $r['history'][$k]['map'] );
    }

    $simple = array();
    foreach( $r['history'] as $k => $v ) {
        $simple[] = $v['simple'];
    }
    $simple = array_reverse($simple);
    $diff = array();

    #for( $i = 0; $i < count($simple)-1; $i++ ) {
        #pre( $simple[$i], false); pre( $simple[$i+1]);
        ######$diff[] = htmlDiff( $simple[$i], $simple[$i+1]);
        ######pre( $diff );
    #}

    #pre($r);
    return( $r );
}


/**
* returns number of activity items
*/
function insights_get_history_rows($where = array(1)) {
    global $db;
    $tbl = TABLE_PREFIX;

    $where_sql = implode(") and (", $where);

    $r = $db->Single()->Query(
        "select count(*) as rows from `${tbl}_history` left join {$tbl}entries on {$tbl}entries.id={$tbl}_history.entry_id where ({$where_sql})"
    );

    return( $r["rows"] );
}

/**
* retrieves activity list, by page
*/
function insights_get_history_page($p = 0, $per_page = 500, $where = array(1)) {
    global $db;
    $tbl = TABLE_PREFIX;

    $where_sql = implode(") and (", $where);

    $limit_b = intval($per_page);
    $limit_a = intval(($p - 1) * $limit_b);

    $r = $db->Query(
        "select
            {$tbl}_history.*,
            {$tbl}entries.slug
        from
            {$tbl}_history
        left join
            {$tbl}entries
        on
            {$tbl}entries.id=${tbl}_history.entry_id
        where
            ({$where_sql})
        order by
            id desc
        limit
            {$limit_a},{$limit_b}"
    );

    return( $r );
}

/**
* gives a breakdown of all add/delete/update/star actions
*/
function insights_get_history_actions() {
    global $db;
    $tbl = TABLE_PREFIX;

    $r = $db->Index("action")->Query(
        "select count(*) AS `rows` , `action`
        FROM `{$tbl}_history`
        GROUP BY `action`
        ORDER BY `action`"
    );

    return( $r );
}

/**
 * Admin-panel function; focuses retrival of all activity
 */
function insights_get_history_data_where(&$where, $field, $field_sql = null, $like = false) {

    if( is_null($field_sql) ) $field_sql = $field;

    if( !isset( $_GET[$field]) ) return(false);

    $field = trim(mysql_real_escape_string($_GET[$field]));
    if( strlen($field) == 0 ) return(false);

    if( $like == false ) {
        $where[] = sprintf("`%s`='%s'", $field_sql, $field);
    } else {
        $where[] = sprintf("`%s` like '%%%s%%'", $field_sql, $field);
    }
}

/**
 * Admin-panel function; retrieves all activity
 */
function insights_get_history_data() {
    $ret = array();

    $tbl = TABLE_PREFIX;
    $per_page = 500;

    $where = array(1);
    insights_get_history_data_where($where, "ip");
    insights_get_history_data_where($where, "id", "entry_id");
    insights_get_history_data_where($where, "slug", "slug", true);

#    if( isset( $_GET['id']) ) $where[] = mysql_real_escape_string($_GET['ip']);
    #if( isset( $_GET['ip']) ) $where[] = mysql_real_escape_string($_GET['ip']);

    $ret["history_rows"] = insights_get_history_rows($where);
    $ret["history_actions"] = insights_get_history_actions($where);

    // easier pagination for smarty
    $pages = array();
    $ret["history_pages"] = array(
        "current" => 1,
        "total" => ceil($ret["history_rows"] / $per_page),
        "list" => array()
    );
    for( $i = 0; $i < $ret["history_pages"]["total"]; $i++ ) {
        $ret["history_pages"]["list"][] = $i + 1;
    }

    if( isset( $_GET['p']) ) {
        $ret["history_pages"]["current"] = intval($_GET['p']);
    }

    $ret["history_entries"] = insights_get_history_page(
        $ret["history_pages"]["current"],
        $per_page,
        $where
    );

    return( $ret );
}
