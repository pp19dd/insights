<?php
if( !defined("INSIGHTS_RUNNING") ) die("Error 211.");

require( "simplediff.php" );

/**
 * makes a backup of an entry, returns copy id  
 */
function insights_backup($entry_id) {
    global $VOA;
    $tbl = TABLE_PREFIX;
    
    # old entry, before changing
    $old = $VOA->query(
        "select * from `{$tbl}entries` where `id`=%s limit 1",
        intval($entry_id),
        array("flat")
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
    $VOA->query(
        "insert into `{$tbl}entries` (`{$keys}`) values ('{$values}');"
    );
    $copy_id = mysql_insert_id();

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
    global $VOA;
    $tbl = TABLE_PREFIX;

    # phase one: make copies of all data associated with this $action_id
    if( $action === 'update' && $skip_copy === false ) {
        $copy_id = insights_backup($entry_id);
        
        # override $note to point to the old entry
        $note = "~" . $copy_id;
    }
    
    # phase two: get action id, record info about user and action
    $VOA->query(
        "insert into `{$tbl}_history` 
            (`ip`, `action`, `entry_id`, `note`) 
        values
            ('%s', '%s', %s, '%s')",
        $_SERVER["REMOTE_ADDR"],
        $action,
        intval( $entry_id ),
        $note
    );

    $action_id = mysql_insert_id();

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
    global $VOA;
    $tbl = TABLE_PREFIX;
    
    $r = array();
    $r['history'] = $VOA->query(
        "select * from `{$tbl}_history` where `entry_id`=%s order by `id` desc",
        $entry_id,
        array("noempty")
    );
    
    foreach( $r['history'] as $k => $v ) {
        
        # if this is an update, get copy of older version entry
        if( $v['action'] === 'update' && substr($v['note'], 0, 1) === '~' ) {
            $old_entry_id = intval(substr( $v['note'], 1 ));
        
            $r['history'][$k]['entry'] = $VOA->query(
                "select * from `{$tbl}entries` where `id`=%s limit 1",
                $old_entry_id,
                array("noempty", "flat")
            );
        }
        
        # find map for entry
        $r['history'][$k]['map'] = $VOA->query(
            "select * from `{$tbl}map` where `action_id`=%s order by `id` asc",
            $v["id"],
            array("noempty")
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
