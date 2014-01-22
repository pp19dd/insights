<?php

/*
given a list of all entries, organize by map type
*/

function insights_group_by( $map_type, &$entries ) {
	$r = array();
	
	foreach( $entries as $entry_id => $entry ) {
		if( !isset( $entry['map'] ) ) continue;
		if( !isset( $entry['map'][$map_type] ) ) continue;
		
		foreach( $entry['map'][$map_type] as $map ) {
			$key = $map['resolved']['name'];
			
			if( !isset($r[$key]) ) {
				$r[$key] = array(
					"starred" => array(),
					"hidden" => array(),
					"all" => array()
				);
			}
			
			if( $entry['is_starred'] == 'Yes' ) {
				$r[$key]['starred'][] = $map['entry_id'];
			} else {
				$r[$key]['hidden'][] = $map['entry_id'];
			}
			$r[$key]['all'][] = $map['entry_id'];
		}
		
		#pre( $entry['map'][$map_type], false );
	}

	return( $r );
}


/*
find a list of all origins, targets, beats and mediums from an entries list
*/
function insights_increment_if_exists( &$a, $map ) {
	$type = $map['type'];
	$entry = $map['resolved']['name'];
	
	if( !isset( $a[$type] ) ) $a[$type] = array();
	
	if( !isset( $a[$type][$entry] ) ) {
		$a[$type][$entry] = 1;
	} else {
		$a[$type][$entry]++;
	}
}

function insights_get_all_maps( $entries ) {
	$all_maps = array();
	foreach( $entries as $e ) {
		foreach( $e['map'] as $type => $resolved ) {
			foreach( $resolved as $map) {
				insights_increment_if_exists( $all_maps, $map );
			}
		}
	}
	
	foreach( $all_maps as $k => $v ) {
		ksort( $all_maps[$k] );
	}
	ksort( $all_maps );
	return( $all_maps );
}



/*
hints for calendar
*/
function insights_activity() {
	global $VOA;
	$tbl = TABLE_PREFIX;

	$t = $VOA->query(
		"select id, date(deadline) as `day`, " .
		"count(date(deadline)) as `count` " .
		"from {$tbl}entries " .
		"where is_deleted='No' " .
		"group by `deadline`",
		array("noempty", "index" => "day")
	);

	
	$t = array_map( function( $e ) {
		return( $e['count'] );
	}, $t);

/*
$t = Array
(
    [2013-12-06] => 2
    [2014-01-10] => 2
    [2014-01-17] => 1
)
*/

	return(array(
		"list" => $t,
		"range" => array(
			"min" => min( $t ),
			"max" => max( $t )
		)
	));
	return( $t );
	
/*
	$t = $VOA->query(
		"select id, date(deadline) as `day` from {$tbl}entries " .
		"where month(deadline)=month(now())",
		array("noempty")
	);
	
	
	pre( $t );
	
	return( array_count_values( array_keys( $t ) ) );
*/	

}

function insights_get_type( $type ) {
	global $VOA;
	$tbl = TABLE_PREFIX;

	$ret = $VOA->query(
		"select * from {$tbl}{$type} where is_deleted='No' order by `name`",
		array("index"=>"id", "noempty")
	);
	
	return( $ret );
}

function insights_get_common_queries( $ts, $ts_tomorrow, $ts_yesterday) {
	global $VOA;
	global $ALLOW_TYPE;
	$tbl = TABLE_PREFIX;
	
	$queries = array(
		"actually_today" => date("Y-m-d"),
		"today" => date("Y-m-d", $ts),
		"tomorrow" => date("Y-m-d", $ts_tomorrow),
		"yesterday" => date("Y-m-d", $ts_yesterday),
		"services_full" => $VOA->query(
			"select " .
			"{$tbl}services.*, {$tbl}divisions.name as `division_name` " .
			"from {$tbl}services " .
			"left join {$tbl}divisions " .
			"on {$tbl}services.division_id = {$tbl}divisions.id " .
			"where {$tbl}services.is_deleted='No'",
			array("index"=>"id")
		),
		"divisions_and_services" => array()
	);
	
	foreach( $ALLOW_TYPE as $type ) $queries[$type] = insights_get_type( $type );
	
	$queries['editors_reduced'] = array_values(array_map( function($e) {
		return(array(
			"id" => $e['id'],
			"text" => $e['name']
		));
	}, $queries['editors'] ));
	
	$queries['reporters_reduced'] = array_values(array_map( function($e) {
		return(array(
			"id" => $e['id'],
			"text" => $e['name']
		));
	}, $queries['reporters'] ));
	
	// used for a pretty dropdown
	foreach( $queries['divisions'] as $division_id => $division ) {
		$key = $queries['divisions'][$division_id]['name'];
		$values = $VOA->query(
			"select * from {$tbl}services where division_id=%s order by name",
			$division_id,
			array("noempty")
		);
		
		foreach( $values as $k => $v ) {
			$queries['divisions_and_services'][$key][$v['id']] = $v['name'];
		}
	}
	
	#pre( $queries );
	return( $queries );
}


