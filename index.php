<?php
require( 'init.php' );

# ============================================================================
# auth
# ============================================================================
$USER = new Insights_User();
$VOA->assign( 'can', $USER->getPermissions() );
$VOA->assign( 'error', $USER->error );

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
if( isset( $_GET['delete'] ) ) {
	insights_action_delete();
}

if( isset( $_POST ) && isset( $_POST['form_type'] ) ) {
	insights_action_add_update();
}

# ============================================================================
# assume view mode: provide common queries, entries and activity
# ============================================================================

if( defined('VOA_DISABLE_FOOTER') ) {
	$VOA->assign('disable_footer', true);
}

$queries = insights_get_common_queries( $ts, $ts_tomorrow, $ts_yesterday );

foreach( $queries as $query => $data ) {
	$VOA->assign( $query, $data );
}

# hint entries for calendar (activity level)
$VOA->assign( 'activity', insights_activity() );

$query_entries = array();

if( isset( $_GET['keywords']) ) {
	
	$words = explode(" ", trim(strip_tags($_GET['keywords'])));
	$query_entries["search"] = $words;
	
} elseif( isset( $_GET['until']) ) {

	// single date mode
	$query_entries["from"] = $_GET['day'];
	$query_entries["to"] = $_GET['until'];
	
} else {
	
	// date range
	$query_entries["date"] = array( $queries["today"] );

}

# $entries = insights_get_entries($queries['today']);
$entries = insights_get_entries($query_entries);
$all_maps = insights_get_all_maps( $entries );



# perform filtration by-group
# 		entries contains entire list
#			we only want entries organized by 
#			[beats, divisions, editors, mediums, regions]
if( isset( $_GET['show'] ) ) {
	$grouped_entries = insights_group_by( $_GET['show'], $entries );
	$VOA->assign( 'grouped_entries', $grouped_entries );
}

$VOA->assign( 'all_maps', $all_maps );
$VOA->assign( 'entries', $entries );

# ============================================================================
# template picker, routed from .htaccess / mod_rewrite
# ============================================================================
$mode = '';
if( isset( $_GET['mode'] ) ) $mode = $_GET['mode'];
if( isset( $_GET['search']) ) $mode = "search";
if( $USER->CAN['view'] === false ) $mode = "403";

switch( $mode ) {
	case '404':			$template = '404.tpl'; break;
	
	case '403':			
		header( "HTTP/1.0 403 Forbidden" );
		$template = "403.tpl";
	break;
	
	case 'search':		$template = 'search.tpl'; break;
	case 'admin': 		$template = 'admin.tpl'; break;
	case 'divisions': 	$template = 'divisions.tpl'; break;	
	case 'services':	$template = 'services.tpl'; break;
	case 'beats':		$template = 'beats.tpl'; break;
	case 'reporters':	$template = 'reporters.tpl'; break;
	case 'editors':		$template = 'editors.tpl'; break;
	
	default:
		$template = 'home.tpl';
		
		if( isset( $_GET['edit'] ) ) {

			# single entry
			$entry_id = intval($_GET['edit']);
			#$entry = insights_get_entries( array($entry_id) );
			$entry = insights_get_entries(array(
				"id" => array($entry_id)
			));
			
			if( is_array( $entry ) && !empty( $entry ) ) {
				$entry = array_shift( $entry );
			}
			
			$VOA->assign( 'entry', $entry );
			
			$history = insights_get_history( $entry_id );
			$VOA->assign( 'history', $history );
			
			$template = 'entry.tpl';
			
		} else {

			// default mode
			if( 
				!isset( $_GET['show'] ) &&
				!isset( $_GET['all'] ) &&
				!isset( $_GET['search'] ) 
			) {
				header( "location:?{$_SERVER['QUERY_STRING']}&show=regions" );
				die;
			}
		}

	break;
}

# ============================================================================
# break caching, template compiling and display
# ============================================================================
$VOA->clearCompiledTemplate( $template );
$VOA->display( $template );
