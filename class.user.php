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
	
	var $error = "";
	
	function __construct() {
		session_start();
		
		$this->CAN = $this->default_CAN;
		$this->applyWhitelist();
		
		if( isset( $_GET['login']) ) {
			$this->tryLogin();
		}
		
		if( isset( $_GET['logout'])) {
			$this->doLogout();
		}
		
		if(
			isset( $_SESSION['logged_in'] ) && 
			$_SESSION['logged_in'] === true
		) {
			$this->CAN['edit'] = true;
			$this->CAN['delete'] = true;
			$this->CAN['star'] = true;
		}
	}
	
	function tryLogin() {
		if( !isset( $_POST['password'] ) ) return( false );
			
		if( md5($_POST['password']) == TEMP_CONF_PWD) {
			$this->doLogin();
		} else {
			$this->error = "Incorrect password.";
		}
	}
	
	function doLogin() {
		$_SESSION['logged_in'] = true;
		$this->CAN['login'] = false;
		$this->CAN['logout'] = true;
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
			}
		}
	}
	
	function getPermissions() {
		return( $this->CAN );
	}
	
}

