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

echo str_repeat(" ", 2048);

for( $i = 0; $i < $count; $i++) {
    $ts = date("r");
    echo "inserting {$i} / {$count} at {$ts}<br/>";
    ob_flush(); flush();

    $E->batchInsert($i);
#    sleep(1);
}
