<?php
define( "INSIGHTS_RUNNING", true );
require( 'init.php' );

# ============================================================================
# auth
# ============================================================================
$USER = new Insights_User();
$is_admin = false;

if( isset($_GET['mode']) && $_GET['mode'] == "admin" ) {
	if( $USER->CAN['star'] === true ) {
		include( "index_admin.php" );
		$is_admin = true;
	}
} else {
	if( $USER->CAN['view'] === true ) {
		include( "index_user.php" );
	}
}

$VOA->assign( "is_admin", $is_admin );

$VOA->assign( 'can', $USER->getPermissions() );
$VOA->assign( 'error', $USER->error );

# ============================================================================
# template picker, routed from .htaccess / mod_rewrite
# ============================================================================
$mode = '';
if( isset( $_GET['mode'] ) ) 	$mode = $_GET['mode'];
if( isset( $_GET['search']) ) 	$mode = "search";
if( isset( $_GET['edit']) ) 	$mode = "edit";

if( $mode === "admin" && $USER->CAN['star'] === false ) $mode = "403";
if( $USER->CAN['view'] === false ) $mode = "403";

switch( $mode ) {
	case 'admin':
		switch( $_GET['page'] ) {
			case 'divisions': 	$template = 'admin_divisions.tpl'; break;
			case 'services':	$template = 'admin_services.tpl'; break;
			case 'beats':		$template = 'admin_beats.tpl'; break;
			case 'reporters':	$template = 'admin_reporters.tpl'; break;
			case 'editors':		$template = 'admin_editors.tpl'; break;
			default:	 		$template = 'admin.tpl'; break;
		}	
	break;
	
	case '404':			$template = '404.tpl'; break;
	case '403':			
		header( "HTTP/1.0 403 Forbidden" );
		$template = "403.tpl";
	break;
	
	case 'search':		$template = 'search.tpl'; break;
	case 'edit':
		# single entry
		$entry_id = intval($_GET['edit']);
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
		break;
		
	default:
		$template = 'home.tpl';
	break;
}

# ============================================================================
# break caching, template compiling and display
# ============================================================================
$VOA->clearCompiledTemplate( $template );
$VOA->display( $template );
