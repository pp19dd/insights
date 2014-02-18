<?php
/*
	it's up to the calling function to make sure $other_ids is broken up into an array
	
	three forms of $other_ids:
	
	1 					- integer 			- single entry
	"new"				- string			- single entry, non-int type creates entry in $try_type table
	array(3,4) 			- array				- multiple entries
	array(3,4,"new")	- mixed array		- multiple entries, non-int type creates entry in $try_type table
*/

function insights_add_map( $try_type, $entry_id, $other_ids, &$ret, $add_new_entry = true ) {
	global $VOA;
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
		
		# echo "<pre style='background-color:silver'>"; echo $try_type . "\t\t"; var_dump( $other_id ); echo "</pre>";
		
		if( !is_numeric( $other_id ) ) {
			
			// skip adding entry since there is no matched value
			if( $add_new_entry !== true ) continue;
				
			$VOA->query(
				"insert into `{$tbl}%s` (`name`) values ('%s')",
				$type,
				$other_id
			);
			
			$other_id = mysql_insert_id();
			
			if( is_array( $ret ) ) {
				if( !isset( $ret['other'][$type] ) ) $ret['other'][$type] = array();
				$ret['other'][$type][] = $other_id;
			}

		}
	
		$VOA->query(
			"insert into `{$tbl}map` (`type`, `entry_id`, `other_id`) values ('%s', '%s', '%s')",
			$type,
			intval( $entry_id ),
			intval( $other_id )
		);
		
		$map_id = mysql_insert_id();
		
		if( is_array( $ret ) ) {
			if( !isset( $ret['map'][$type] ) ) $ret['map'][$type] = array();
			$ret['map'][$type][] = $map_id;
		}
	}
}

function insights_delete_entry( $entry_id ) {
	global $VOA;
	$tbl = TABLE_PREFIX;
	
	$VOA->query(
		"update `{$tbl}entries` set `is_deleted`='Yes' where `id`=%s limit 1",
		intval( $entry_id )
	);
}

function insights_star( $entry_id, $star = 'Yes' ) {
	global $VOA;
	$tbl = TABLE_PREFIX;

	$VOA->query(
		"update `{$tbl}entries` set `is_starred`='%s' where `id`=%s limit 1",
		$star,
		intval( $entry_id )
	);
	
	#echo $VOA->sql; 	echo mysql_error(); 	die;
}

function insights_clear_map( $entry_id ) {
	global $VOA;
	$tbl = TABLE_PREFIX;

	$VOA->query(
		"update `{$tbl}map` set `is_deleted`='Yes' where `entry_id`=%s",
		intval( $entry_id )
	);
}

/*
returns an array of entries (and meta)
*/
function insights_add_insight( $p, $requesting_entry_id = -1 ) {
	global $VOA;
	global $ALLOW_TYPE;
	
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
		$VOA->query(
			"insert into `{$tbl}entries` (id) values (null)"
		);
		$entry_id = mysql_insert_id();
	} else {
		$entry_id = intval( $requesting_entry_id );
	}
	
	// zero-time?
	$VOA->query(
		"update `{$tbl}entries` set `is_deleted`='No', `slug`='%s', `description`='%s', `deadline`='%s %s:00:00' where `id`=%s limit 1",
		trim(strip_tags($p['slug'])),
		trim(strip_tags($p['description'])),
		date("Y-m-d", strtotime($p['deadline'])),
		str_pad(intval($p["deadline_time"]), 2, "0", STR_PAD_LEFT),
		$entry_id
	);
	
	$ret["entries"][] = $entry_id;
	
	insights_clear_map( $entry_id );

	#					table													 	  insert new entry?
	insights_add_map( 'reporters', 	$entry_id, explode(",", $p['reporters']), 	$ret, true );
	insights_add_map( 'editors', 	$entry_id, explode(",", $p['editors']), 	$ret, true );
	insights_add_map( 'beats', 		$entry_id, $p['beats'], 					$ret, false );
	insights_add_map( 'mediums', 	$entry_id, $p['mediums'], 					$ret, false );
	
	insights_add_map( 'regions', 	$entry_id, $p['regions'], 					$ret, false );
	
	// lookup table
	$services = insights_get_type( "services" );
	
	if( isset( $p['origin']) && isset($services[$p['origin']]) ) {
		$division_id = intval($services[$p['origin']]['division_id']);
		insights_add_map( 'divisions', 	$entry_id, $division_id, 					$ret, false );
		insights_add_map( 'services', 	$entry_id, $p['origin'], 					$ret, false );
	}
	
	return( $ret );
}
