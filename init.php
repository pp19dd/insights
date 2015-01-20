<?php
if( !defined("INSIGHTS_RUNNING") ) die("Error 211.");

define( "VERSION", "1.10" );

require( 'vendor/autoload.php' );
require( 'config.php' );
require_once( 'functions.php' );
require_once( 'functions_read.php' );
require_once( 'functions_write.php' );
require_once( 'functions_action.php' );
require_once( 'functions_history.php' );
require_once( 'functions_smarty.php' );
require_once( 'functions_search.php' );
require_once( 'class.range.php' );
require_once( 'class.url.php' );
require_once( 'class.user.php' );
require_once( 'class.elastic.php' );
require_once( 'class.db.php' );

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

# porting to an updated db version
# require_once( 'voa.php' );

$smarty = new Smarty();
$smarty->assign( 'base_url', VOA_BASE_URL );
$smarty->assign( 'version', VERSION);
$smarty->compile_id = $_SERVER['HTTP_HOST'];
$db = new VOA_DB(
	VOA_DATABASE__HOST,
	VOA_SELECT_DATABASE,
	VOA_DATABASE__USER,
	VOA_DATABASE__PASS
);
