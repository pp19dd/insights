<?php

class Insights_User {
	
	var $CAN = array();
	var $default_CAN = array(
		"login" => true,		// login routine inverts
		"logout" => false,		// these two

		"view" => true,			// default
			
		"add" => false,			// whitelisted / logged in
		"edit" => false,
		"delete" => false,

		"star" => false			// admin login
	);

	var $notes = array();
	var $error = "";
	
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
			$this->login_flag( false, true );
			
			$this->CAN['add'] = true;
			$this->CAN['edit'] = true;
			$this->CAN['delete'] = true;
			$this->CAN['star'] = true;
			
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
			
		if( md5($_POST['password']) == TEMP_CONF_PWD) {
			$this->doLogin();
			return( true );
		} else {
			$this->error = "Incorrect password.";
			return( false );
		}
	}
	
	function doLogin() {
		$_SESSION['logged_in'] = true;
		$this->login_flag( false, true );
	}
	
	function doLogout() {
		$_SESSION['logged_in'] = false;
		unset( $_SESSION['logged_in'] );
		
		$this->CAN = $this->default_CAN;
	}
	
	function applyWhitelist() {
		$allowed = explode('/', WHITELIST);
		foreach( $allowed as $allow ) {
			if( strpos($_SERVER['REMOTE_ADDR'], $allow) === 0 ) {
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

