<?php
if( !defined("INSIGHTS_RUNNING") ) die("Error 211.");

/*
 * executes an insight deletion
 * 
 * required: previously constructed $USER, $_GET['delete'] 
 */

function insights_action_delete() {
	
	global $USER;
	
	if( $USER->CAN['delete'] === false ) {
		die( "error: you don't have permission to delete records");
	}
	
	insights_delete_entry( intval($_GET['delete']) );
	
	$URL = new Rewrite_URL();
	$URL->erase( "delete" );
	$URL->erase( "edit" );
	$URL->set( "deleted", intval( $_GET['delete']) );
	
	header("location:" . (String)$URL);
	
	die;
	
}

/*
 * executes an insight addition/update
 * 
 * required: previously constructed $VOA, $USER, $_POST [ ... ]
 */

function insights_action_add_update() {
	global $USER;
	global $VOA;

	switch( $_POST['form_type'] ) {
		case 'add_insight':
			
			if( $USER->CAN['add'] === false ) {
				die("error: you don't have permission to ADD records.");
			}
				
			$r = insights_add_insight( $_POST );
	
			$VOA->assign( 'entry_added', array(
					"posted" => $_POST,
					"returned" => $r
			));
			break;
	
		case 'update_insight':
			if( $USER->CAN['edit'] === false ) {
				die("error: you don't have permission to EDIT records.");
			}
			
			$posted_entry_id = intval( $_POST['entry_id'] );

			# before updating, look at previous version
			# $old_entry = insights_get_entries( array($posted_entry_id) );
			$old_entry = insights_get_entries(array(
				"id" => array($posted_entry_id)
			));
				
			$old_entry = array_shift( $old_entry );

			# make the update
			$r = insights_add_insight( $_POST, $posted_entry_id );
			
			// consider star only for logged in users
			if( $USER->CAN['star'] === true ) {
				
				// only update star if needed
				if( isset( $_POST['star'] ) ) {
					$wanted_star_state = "Yes";
				} else {
					$wanted_star_state = "No";
				}
				
				if( $old_entry["is_starred"] != $wanted_star_state ) {
					insights_star( $posted_entry_id, $wanted_star_state );
				}
			}
				
			$VOA->assign( 'entry_added', array(
					"posted" => $_POST,
					"returned" => $r
			));
			$VOA->assign( 'entry_updated', true );
			break;
	
		default:
			pre( $_POST );
			die;
			break;
	}	
}
