<?php

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
				
			$r = insights_add_insight( $_POST, intval($_POST['entry_id']) );
				
			// consider star for logged in users
			if( $USER->CAN['star'] === true ) {
				if( isset( $_POST['star'] ) ) {
					insights_star( intval( $_POST['entry_id']), 'Yes' );
				} else {
					insights_star( intval( $_POST['entry_id']), 'No' );
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
