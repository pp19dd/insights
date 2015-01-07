<?php
if( !defined("INSIGHTS_RUNNING") ) die("Error 211.");

/**
 * given a list of all entries, organize by map type
 */

function insights_group_by( $map_type, &$entries ) {
	$r = array();

	foreach( $entries as $entry_id => $entry ) {
		if( !isset( $entry['map'] ) ) continue;
		if( !isset( $entry['map'][$map_type] ) ) continue;

		foreach( $entry['map'][$map_type] as $map ) {

			if( !isset($map['resolved']) ) continue;
			if( !isset($map['resolved']['name'])) continue;

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

	}

	return( $r );
}


/**
 * find a list of all origins, targets, beats and mediums from an entries list
 */

function insights_increment_if_exists( &$a, $map ) {
	$type = $map['type'];
	if( isset($map['resolved']) && isset($map['resolved']['name']) ) {
		$entry = $map['resolved']['name'];
	} else {
		return;
	}

	if( !isset( $a[$type] ) ) $a[$type] = array();

	if( !isset( $a[$type][$entry] ) ) {
		$a[$type][$entry] = 1;
	} else {
		$a[$type][$entry]++;
	}
}

/**
 * loops through insight entries and returns a list of unique maps
 * ex: beats / divisions / editors / mediums / etc
 *
 * @var $entries Object
 */

function insights_get_all_maps( $entries ) {
	global $ALLOW_TYPE;

	$all_maps = array();

	// mapping routine should show all pertinent types
	foreach( $ALLOW_TYPE as $v ) {
		$all_maps[$v] = array();
	}

	$empty_count = 0;

	foreach( $entries as $e ) {

		$map_count = 0;

		foreach( $e['map'] as $type => $resolved ) {
			$map_count += count($resolved);

			foreach( $resolved as $map) {
				insights_increment_if_exists( $all_maps, $map );
			}
		}

		if( $map_count == 0) {
			$empty_count++;
		}

	}

	foreach( $all_maps as $k => $v ) {
		ksort( $all_maps[$k] );
	}
	ksort( $all_maps );
	return( array(
		"all_maps" => $all_maps,
		"empty" => $empty_count
	));
}



/**
 * provides hints for calendar - entries per day
 *
 * @return array containing list (date => count), range (min, max)
 */
function insights_activity() {
	global $VOA;
	$tbl = TABLE_PREFIX;

	$t = $VOA->query(
		"select
			`id`,
			`deadline` as `day`,
			count(date(deadline)) as `count`
		from
			`{$tbl}entries`
		where
			`is_deleted`='No' and
			`deadline` is not null
		group by
			`deadline`",
		array("noempty", "index" => "day")
	);

	$HFR = $VOA->query(
		"select count(id) as `count` from `{$tbl}entries` where `deadline` is null",
		array("flat")
	);

	$t = array_map( function( $e ) {
		return( $e['count'] );
	}, $t);

	return(array(
		"list" => $t,
		"hfr" => $HFR["count"],
		"range" => array(
			"min" => min( $t ),
			"max" => max( $t )
		)
	));
}

/**
 * helper function, queries metadata associated with an entry.
 *
 * @param $type String table name, beats / services / etc
 */
function insights_get_type( $type ) {
	global $VOA;
	$tbl = TABLE_PREFIX;

	$ret = $VOA->query(
		"select
			`{$tbl}{$type}`.*,
			(
				select
					count(`{$tbl}map`.`entry_id`)
				from
					`{$tbl}map`
				where
					`{$tbl}map`.`type`='{$type}' and
					`{$tbl}map`.`other_id`=`{$tbl}{$type}`.`id` and
					`{$tbl}map`.`is_deleted`='No'
			) as `count`
		from
			{$tbl}{$type}
		where
			`{$tbl}{$type}`.`is_deleted`='No'
		order by
			`name`",
		array("index"=>"id", "noempty")
	);

	return( $ret );
}

/**
 * filters editors / reporters
 * @param unknown $input
 */
function insights_autocomplete_filter( $input ) {
	$ret = array();
	foreach( $input as $k => $v ) {
		if( $v["count"] == 0 ) continue;

		$ret[] = array("id" => $v["id"], "text" => $v["name"] );
	}
	return( $ret );
}

/**
 * Returns filtered array containing elements where count > 0
 * @param Array $arr
 */
function insights_nonzero_count_filter( $element ) {
	if( $element["count"] <= 0 ) return( false );
	return( true );
}

/**
 * returns helper items for the templating system.
 * navigation helpers, names of services, config
 */
function insights_get_common_queries() {
	global $VOA;
	global $ALLOW_TYPE;
	$tbl = TABLE_PREFIX;

	$queries = array(
		//"actually_today" => date("Y-m-d"),
		//"today" => date("Y-m-d", $ts),
		//"tomorrow" => date("Y-m-d", $ts_tomorrow),
		//"yesterday" => date("Y-m-d", $ts_yesterday),
		"preslugs" => array(
			"VEL" => "VEL",
			"VPKG" => "VPKG",
			"CR" => "CR",
			"WEB" => "WEB"
		),
		"hours" => array(),
		"services_full" => $VOA->query(
			"select
				{$tbl}services.*,
				{$tbl}divisions.name as `division_name`
			from
				{$tbl}services
			left join
				{$tbl}divisions
			on
				{$tbl}services.division_id = {$tbl}divisions.id
			where
				{$tbl}services.is_deleted='No'",
			array("index"=>"id")
		),
		"divisions_and_services" => array(),
		"config" => $VOA->query(
			"select * from {$tbl}_config",
			array("index"=>"symbol")
		)
	);

	foreach( $ALLOW_TYPE as $type ) {
		$queries[$type] = insights_get_type( $type );
	}

	# hours for a selector dropdown
	for( $h = 0; $h < 24; $h++ ) {
		$ts_1 = strtotime("midnight +{$h} hour");
		$value = sprintf( "%s", date("H:i", $ts_1));
		$friendly = sprintf( "%s (%s) EST", date("H:i", $ts_1 ), date("g a", $ts_1) );

		$queries["hours"][$value] = $friendly;
	}

	$queries["editors_reduced"] = insights_autocomplete_filter( $queries["editors"] );
	$queries["reporters_reduced"] = insights_autocomplete_filter( $queries["reporters"] );

	# used for a pretty dropdown
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

	return( $queries );
}

/**
* returns number of activity items
*/
function insights_get_history_rows($where = array(1)) {
	global $VOA;
	$tbl = TABLE_PREFIX;

	$where_sql = implode(") and (", $where);

	$r = $VOA->query(
		"select count(*) as rows from `${tbl}_history` where ({$where_sql})", array("flat")
	);

	return( $r["rows"] );
}

/**
* retrieves activity list, by page
*/
function insights_get_history_page($p = 0, $per_page = 500, $where = array(1)) {
	global $VOA;
	$tbl = TABLE_PREFIX;

	$where_sql = implode(") and (", $where);

	$limit_b = $per_page;
	$limit_a = ($p - 1) * $limit_b;

	$r = $VOA->query(
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
	#print_r( error_get_last() );
	#echo mysql_error();
	#pre($r);
	#pre($VOA);
	#pre($VOA->sql);
	return( $r );
}

/**
* gives a breakdown of all add/delete/update/star actions
*/
function insights_get_history_actions() {
	global $VOA;
	$tbl = TABLE_PREFIX;

	$r = $VOA->query(
		"select count(*) AS `rows` , `action`
		FROM `{$tbl}_history`
		GROUP BY `action`
		ORDER BY `action`",
		array("index" => "action")
	);

	return( $r );
}

/**
* explodes comma-separated array, with integer filtering
*/
function insights_string_to_watchlist($str) {
	$t = explode(",", $str);
	foreach( $t as $k => $v ) {
		$ret[] = intval($v);
	}
	return( $ret );
}

/**
* gets an array of entry IDs from a cookie
*/
function insights_get_watchlist() {
	$ret = array();
	if( !isset( $_COOKIE["insights_watch_list"]) ) return($ret);
	$ret = insights_string_to_watchlist($_COOKIE["insights_watch_list"]);
	return( array_unique($ret) );
}

/**
* saves an array of entry IDs as a cookie
*/
function insights_save_watchlist($a) {
	$str = implode(",", $a);

	$expire = 60 * 60 * 24 * 365;
	setcookie( "insights_watch_list", $str, time() + $expire, "/");
}
