<?php
# ============================================================================
# alter this section
# ============================================================================

define( 'TEMP_CONF_PWD', "md5-hash-of-temp-admin-pwd" );

if( $_SERVER['HTTP_HOST'] == 'localhost' ) {
	define( 'VOA_BASE_URL',		'http://localhost/insights/' );
	define( 'VOA_BASE_DIR',		'./' );
} else { 
	define( 'VOA_BASE_URL',		'http://www.example.com/insights/' );
	define( 'VOA_BASE_DIR',		'./' );
}

define( 'VOA_DATABASE__USER',	'mysql_username' );
define( 'VOA_DATABASE__PASS',	'mysql_password' );
define( 'VOA_SELECT_DATABASE',	'mysql_database' );

define( 'TABLE_PREFIX',			'insights_' );

# ============================================================================
# leave below untouched
# ============================================================================

$ALLOW_TYPE = array(
	'reporters',
	'editors',
	'divisions',
	'services',
	'beats',
	'mediums',
	'regions'
);

# require_once( $_SERVER['DOCUMENT_ROOT'] . '/voa.lib/voa.php' );
require_once( 'voa.php' );

$VOA->setTemplateDir( VOA_BASE_DIR . 'templates');
$VOA->setCompileDir( VOA_BASE_DIR . 'templates_c');
$VOA->setCacheDir( VOA_BASE_DIR . 'cache');
$VOA->setConfigDir( VOA_BASE_DIR . 'configs');

$VOA->template_dir = realpath("templates");
$VOA->assign( 'base_url', VOA_BASE_URL );
