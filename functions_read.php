<?php

/**
 * retrieves full listing for an entry from a metadata table
 * 
 * @param $table String Partial table ex: beats, services, etc
 * @param $is_deleted String Yes or No
 * @param $id Integer table.id
 */
function resolve_map($table, $id, $is_deleted = 'No') {
	global $VOA;
	$tbl = TABLE_PREFIX;

	$t = $VOA->query(
		"select * from `{$tbl}%s` where `id`=%s and `is_deleted`='%s'",
		$table,
		intval($id),
		$is_deleted,
		array("noempty", "flat")
	);

	return( $t );
}

/**
 * returns metadata for a particular entry (reporters, beats, divisions, etc)
 * 
 * @param $entry_id int corresponds to insights_entry.id
 * @param $is_deleted String "Yes" or "No"
 */

function insights_map($entry_id, $is_deleted = 'No') {
	global $VOA;
	global $ALLOW_TYPE;
	$tbl = TABLE_PREFIX;

	$t = $VOA->query(
		"select 
			* 
		from 
			`{$tbl}map` 
		where 
			`entry_id`=%s and `is_deleted`='%s'",
		intval( $entry_id ),
		$is_deleted,
		array(
			"noempty", 
			"index" => "type",
			"deep",
			"index2" => "other_id"
		)
	);
	
	// mapping routine should show all pertinent types
	foreach( $ALLOW_TYPE as $v ) {
		if( !isset($t[$v])) $t[$v] = array();
	}
	
	// $k = reporters, beats
	foreach( $t as $k => $v ) {
	
		// $k2 = 0,1,2,3   $v2 = [type, entry_id, other_id], [...]
		foreach( $t[$k] as $k2 => $v2 ) {
			$t[$k][$k2]['resolved'] = resolve_map(
				$v2['type'],
				$v2['other_id'],
				$is_deleted
			);
		}
		
	}
	
	return( $t );
}

/**
 * retrieves entries
 * 
 * @param $date 		null 		queries today's entries
 * @param $date 		String 		queries entries for a specific Y-m-d date.
 * @param $date 		Array 		queries specific ids
 * @param $is_deleted 	String 		Yes or No 
 */
function insights_get_entries( $date = null, $is_deleted = 'No' ) {
	global $VOA;
	$tbl = TABLE_PREFIX;
	
	// default: today
	if( is_null($date) ) $date = date("Y-m-d");

	// array = specific request
	if( is_array($date) ) {
		$ids = $date;
		$date = 'list';
	}
	
	switch( $date ) {
		case 'all':
			$t = $VOA->query(
				"select * from `{$tbl}entries` where `is_deleted`='%s'",
				$is_deleted,
				array("noempty", "index"=>"id")
			);
		break;
		
		case 'list':
			$t = $VOA->query(
				"select * from `{$tbl}entries` where /*`is_deleted`='%s' and*/ `id` in (%s)",
				$is_deleted,
				implode(",", $ids),
				array("noempty")
			);
		break;
		
		default:
			$t = $VOA->query(
				"select * from `{$tbl}entries` where date(`deadline`)='%s' and `is_deleted`='%s'",
				$date,
				$is_deleted,
				array("noempty", "index"=>"id")
			);
		break;
	}
	
	# get metadata for the entries
	foreach( $t as $k => $v ) {
		$t[$k]['map'] = insights_map( $v['id'], $is_deleted );
	}

	return( $t );
}
