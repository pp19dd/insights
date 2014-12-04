<?php


/**
 * temporary user schema
 * 
 * access level  0 = no access
 * access level  5 = view/add/edit
 * access level 10 = view/add/edit/star
 */

class Insights_User {
	
	var $CAN = array();
	var $default_CAN = array(
		"login" => true,		// login routine inverts
		"logout" => false,		// these two

		"view" => false,		// default
		"add" => false,
		"edit" => false,
		"delete" => false,

		"star" => false			// admin login
	);

	var $notes = array();
	var $error = "";
	var $level = 0;
	
	function __construct() {
		session_start();
		
		$this->CAN = $this->default_CAN;
		$this->applyWhitelist();
		
		$URL = new Rewrite_URL();
		if( isset( $_GET['login']) ) $this->tryLogin();
		if( isset( $_GET['logout'])) $this->doLogout();

		if(
			isset( $_SESSION['logged_in'] ) && 
			$_SESSION['logged_in'] === true
		) {
		
			$this->level = $_SESSION['access_level'];
			$this->login_flag( false, true );
			
			if( $_SESSION['access_level'] >= 5 ) {
				$this->CAN['view'] = true;
				$this->CAN['add'] = true;
				$this->CAN['edit'] = true;
				$this->CAN['delete'] = true;
			}
			
			if( $_SESSION['access_level'] >= 10 ) {
				$this->CAN['star'] = true;
			}
			
			$this->notes["logged_in"] = true;
		}

		// redirect after action
		if( isset( $_GET['login'] ) || isset( $_GET['logout'] ) ) {
			$URL->erase("login");
			$URL->erase("logout");
			header("location:" . (String)$URL);
			die;
		}
	}
	
	function login_flag($login = true, $logout = false) {
		$this->CAN['login'] = $login;
		$this->CAN['logout'] = $logout;
	}
	
	function tryLogin() {
		if( !isset( $_POST['password'] ) ) return( false );
		
		$requested_level = 0;
		if( md5($_POST['password']) == TEMP_EDIT_PWD ) $requested_level = 5;
		if( md5($_POST['password']) == TEMP_CONF_PWD ) $requested_level = 10;
		
		if( $requested_level > 0 ) {
			$this->doLogin( $requested_level );
			return( true );
		} else {
			$this->error = "Incorrect password.";
			return( false );
		}
	}

	function doLogin($level = 0) {
		
		$this->level = $level;
		
		$_SESSION['logged_in'] = true;
		$_SESSION['access_level'] = $level;
		
		$this->login_flag( false, true );
	}
	
	function doLogout() {
		$_SESSION['logged_in'] = false;
		$_SESSION['access_level'] = 0;
		
		$this->level = 0;
		
		unset( $_SESSION['logged_in'] );
		unset( $_SESSION['access_level'] );
		
		$this->CAN = $this->default_CAN;
	}
	
	function applyWhitelist() {
		$allowed = explode('/', WHITELIST);
		foreach( $allowed as $allow ) {
			if( strpos($_SERVER['REMOTE_ADDR'], $allow) === 0 ) {
				
				$this->CAN['view'] = true;
				$this->CAN['edit'] = true;
				$this->CAN['add'] = true;
				$this->CAN['delete'] = true;
				
				$this->notes["whitelist"] = true;
			}
		}
	}
	
	function getPermissions() {
		return( $this->CAN );
	}
	
}

