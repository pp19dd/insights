<?php
if( !defined("INSIGHTS_RUNNING") ) die("Error 211.");

require( "config.php" );
require_once( 'functions.php' );
require_once( 'functions_read.php' );
require_once( 'functions_write.php' );
require_once( 'functions_action.php' );
require_once( 'functions_history.php' );
require_once( 'class.range.php' );
require_once( 'class.api.php' );
require_once( 'class.url.php' );
require_once( 'class.user.php');

// table name fragments: main portion
$INSIGHTS_TABLES = array(
	'entries',
	'map',
	'_config',
	'_history'
);

// table name fragments: fundamental configurations for project
$ALLOW_TYPE = array(
	'reporters',
	'editors',
	'divisions',
	'services',
	'beats',
	'mediums',
	'regions'
);

require_once( 'voa.php' );

/*
$VOA->setTemplateDir( realpath( VOA_BASE_DIR . 'templates') );
$VOA->setCompileDir( realpath( VOA_BASE_DIR . 'templates_c') );
$VOA->setCacheDir( realpath( VOA_BASE_DIR . 'cache' ) );
$VOA->setConfigDir( realpath( VOA_BASE_DIR . 'configs' ) );
$VOA->template_dir = realpath("templates");
*/
$VOA->assign( 'base_url', VOA_BASE_URL );
