<?php

/**
 * stores change information, copies original entry
 * 
 *  @param $entry_id integer entries.id
 *  @param $action String (add, update, delete, star)
 *  @param $note String optional note (ex: function parameter)
 *  @return integer Action ID (newly inserted into __history)
 */

function insights_history( $entry_id, $action, $note = '' ) {
	global $VOA;
	$tbl = TABLE_PREFIX;

	# phase one: get action id, record info about user and action
	
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

	# phase two: make copies of all data associated with this $action_id 
	if( $action === 'update' ) {
		
	}
	
	return( $action_id );
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
		$entry_id
	);
	
	foreach( $r['history'] as $k => $v ) {
		#$r['history'][$k] = 
	}

	return( $r );
}
