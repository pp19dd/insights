<?php
# ============================================================================
# alter this section
# ============================================================================

define( 'VOA_SMARTY_VERSION', 'Smarty-3.1.16' );
define( 'TEMP_CONF_PWD', "md5-hash-of-temp-admin-pwd" );

if( $_SERVER['HTTP_HOST'] == 'localhost' ) {
	define( 'VOA_BASE_URL',		'http://localhost/insights/' );
	define( 'VOA_BASE_DIR',		'./' );
	define( 'VOA_DISABLE_FOOTER', true );
	define( 'WHITELIST',		'127.0.0.1/::1' );
} else { 
	define( 'VOA_BASE_URL',		'http://www.example.com/insights/' );
	define( 'VOA_BASE_DIR',		'./' );
	define( 'WHITELIST',		'1.2.3.4' );
	error_reporting( 0 );
}

define( 'VOA_DATABASE__USER',	'mysql_username' );
define( 'VOA_DATABASE__PASS',	'mysql_password' );
define( 'VOA_SELECT_DATABASE',	'mysql_database' );

define( 'TABLE_PREFIX',			'insights_' );

