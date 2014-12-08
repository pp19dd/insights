<?php
# ============================================================================
# alter this section
# ============================================================================

define( 'TEMP_CONF_PWD', "md5-hash-of-temp-admin-pwd" );
define( 'TEMP_EDIT_PWD', "md5-hash-of-temp-user-pwd" );
define( 'API_KEY', 		 "md5-hash-of-api-pwd" );

if( $_SERVER['HTTP_HOST'] == 'localhost' ) {

	define( 'VOA_DATABASE__HOST',	'127.0.0.1' );
	define( 'VOA_BASE_URL',			'http://localhost/insights/' );
	define( 'VOA_BASE_DIR',			'./' );
	define( 'VOA_DISABLE_FOOTER', 	true );
	define( 'WHITELIST',			'127.0.0.1/::1' );
	#define( 'WHITELIST',			'notfound' );

	define( "INSIGHTS_DEVELOPMENT", true );
	define( "SYNC_URL", "http://tools.voanews.com/insights/api.php" );

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

define( 'ELASTICSEARCH_HOST',	'localhost:9200' );
define( 'ELASTICSEARCH_USER',	'elastic_username' );
define( 'ELASTICSEARCH_PASS',	'elastic_password' );
