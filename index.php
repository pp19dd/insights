<?php
require_once( 'config.php' );
require_once( 'functions.php' );
require_once( 'functions_read.php' );
require_once( 'functions_write.php' );

error_reporting( 0 );
session_start();

# ============================================================================
# login/auth/starring - cheap until later...
# ============================================================================
if( isset( $_GET['logout'] ) ) {
	$_SESSION['logged_in'] = false;
}
if( isset( $_GET['login'] ) && isset( $_POST['password'] ) ) {
	$pwd = TEMP_CONF_PWD;
	if( md5($_POST['password']) == $pwd ) {
		
		$_SESSION['logged_in'] = true;
		
	} else {
		$VOA->assign( 'error', "Incorrect password." );
	}
}

if( isset( $_SESSION['logged_in'] ) && $_SESSION['logged_in'] == true ) {
	$VOA->assign( 'logged_in', true );
} else {
	$VOA->assign( 'logged_in', false );
}


# ============================================================================
# calendar navigation / general queries
# ============================================================================
$ts = time();
if( isset( $_GET['day'] ) ) $ts = strtotime($_GET['day']);
$ts_tomorrow = strtotime("+1 day", $ts);
$ts_yesterday = strtotime("-1 day", $ts);

# ============================================================================
# ajax / post mode?
# ============================================================================
if( isset( $_POST ) && isset( $_POST['form_type'] ) ) {
	switch( $_POST['form_type'] ) {
		case 'add_insight':
			$r = insights_add_insight( $_POST );

			$VOA->assign( 'entry_added', array(
				"posted" => $_POST,
				"returned" => $r
			));
		break;
		
		case 'update_insight':
			$r = insights_add_insight( $_POST, intval($_POST['entry_id']) );
			
			// consider star for logged in users
			if( isset( $_SESSION['logged_in'] ) && $_SESSION['logged_in'] == true ) {
			
				if( isset( $_POST['star'] ) ) {
					# pre( "enable star" );
					insights_star( intval( $_POST['entry_id']), 'Yes' );
				} else {
					# pre( "disable star" );
					insights_star( intval( $_POST['entry_id']), 'No' );
				}
			}
			
			$VOA->assign( 'entry_added', array(
				"posted" => $_POST,
				"returned" => $r
			));
			$VOA->assign( 'entry_updated', true );
			# unset( $_GET['edit'] );
			#echo "ok this is update_insight?<hr/>";
			#pre( $_POST );
		break;
		
		default:
			pre( $_POST );
			die;
		break;
	}
}



# ============================================================================
# common queries, entries and activity
# ============================================================================

$queries = insights_get_common_queries( $ts, $ts_tomorrow, $ts_yesterday );
foreach( $queries as $query => $data ) $VOA->assign( $query, $data );

# hint entries for calendar (activity level)
$VOA->assign( 'activity', insights_activity() );

# entries and relevant metadata
# $t = insights_get_entries("2013-12-06");
#######					$entries = insights_get_entries("all");

$entries = insights_get_entries($queries['today']);
$all_maps = insights_get_all_maps( $entries );

# perform filtration by-group
# 		entries contains entire list
#			we only want entries organized by [beats, divisions, editors, mediums, regions]
if( isset( $_GET['show'] ) ) {
	$grouped_entries = insights_group_by( $_GET['show'], $entries );
}

$VOA->assign( 'grouped_entries', $grouped_entries );
#pre( $sorted_entries );
#pre( $all_maps, false );	pre( $entries );


$VOA->assign( 'all_maps', $all_maps );
$VOA->assign( 'entries', $entries );

# ============================================================================
# template picker, routed from .htaccess / mod_rewrite
# ============================================================================
$mode = '';
if( isset( $_GET['mode'] ) ) $mode = $_GET['mode'];

switch( $mode ) {
	case 'admin':
		$template = 'admin.tpl';
	break;
	
	case 'divisions':
		$template = 'divisions.tpl';
	break;
	
	case 'services':
		$template = 'services.tpl';
	break;
	
	case 'beats':
		$template = 'beats.tpl';
	break;
	
	case 'reporters':
		$template = 'reporters.tpl';
	break;
	
	case 'editors':
		$template = 'editors.tpl';
	break;
	
	default:
		$template = 'home.tpl';
		
		if( isset( $_GET['edit'] ) ) {

			# single entry
			$entry = insights_get_entries( array(intval($_GET['edit'])) );
			if( is_array( $entry ) && !empty( $entry ) ) $entry = array_shift( $entry );
			$VOA->assign( 'entry', $entry );
			
			$template = 'entry.tpl';
			
		} else {

			// default mode
			if( !isset( $_GET['show'] ) && !isset( $_GET['all'] ) ) {
				header( "location:?{$_SERVER['QUERY_STRING']}&show=regions" );
				die;
			}
		}

	break;
}


if( isset( $_GET['delete'] ) ) {
	pre( $_GET );
}

# ============================================================================
# break caching, template compiling and display
# ============================================================================
$VOA->clearCompiledTemplate( $template );
$VOA->display( $template );

