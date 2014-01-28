<?php
# ============================================================================
# alter this section
# ============================================================================

define( 'TEMP_CONF_PWD', "md5-hash-of-temp-admin-pwd" );

if( $_SERVER['HTTP_HOST'] == 'localhost' ) {
	
	define( 'VOA_DATABASE__HOST',	'127.0.0.1' );
	define( 'VOA_BASE_URL',			'http://localhost/insights/' );
	define( 'VOA_BASE_DIR',			'./' );
	define( 'VOA_DISABLE_FOOTER', 	true );
	define( 'WHITELIST',			'127.0.0.1/::1' );
	#define( 'WHITELIST',			'notfound' );
	
} else {
	
	define( 'VOA_DATABASE__HOST',	'127.0.0.1' );
	define( 'VOA_BASE_URL',			'http://www.example.com/insights/' );
	define( 'VOA_BASE_DIR',			'/home/directory/' );
	define( 'WHITELIST',			'1.2.3.4.5.6.' );
	error_reporting( 0 );
	
}

define( 'VOA_DATABASE__USER',	'mysql-username-here' );
define( 'VOA_DATABASE__PASS',	'mysql-password-here' );
define( 'VOA_SELECT_DATABASE',	'mysql-database-here' );

define( 'TABLE_PREFIX',			'insights_' );

define( 'VOA_SMARTY_VERSION',	'Smarty-3.1.16' );
