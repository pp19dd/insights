<?php
define( "INSIGHTS_RUNNING", true );
set_time_limit( 0 );

require( "class.elastic.php" );
require( "init.php" );

$E = new Insights_ElasticSearch();

### $t = $E->getEntry(1);

$E->deleteIndex();
$E->createIndex();

$count = $E->getBatchCount();

for( $i = 0; $i < $count; $i++) {
    $E->batchInsert($i);
}
