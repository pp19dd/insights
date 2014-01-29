<?php
require( "config.php" );
require_once( 'functions.php' );
require_once( 'functions_read.php' );
require_once( 'functions_write.php' );
require_once( 'class.url.php' );
require_once( 'class.user.php');

// fundamental configurations for project
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