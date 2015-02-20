<?php

function smarty_modifier_ago($tm, $cur_tm = null) {
    if( is_null($cur_tm) ) $cur_tm = time();
    $dif = $cur_tm-strtotime($tm);

    $pds = array('second','minute','hour','day','week','month','year','decade');
    $lngh = array(1,60,3600,86400,604800,2630880,31570560,315705600);
    for($v = sizeof($lngh)-1; ($v >= 0)&&(($no = $dif/$lngh[$v])<=1); $v--);
    if($v < 0) $v = 0;
    $_tm = $cur_tm-($dif%$lngh[$v]);
    $no = floor($no); if($no <> 1) $pds[$v] .='s'; $x=sprintf("%d %s ",$no,$pds[$v]);

    return $x;
}

function smarty_block_aggregate($parms, $content, &$smarty, &$repeat ) {

    if( $repeat ) {

        $ret = sprintf(
            "%s %s%s",
            trim($parms["input"]),
            $parms["prefix"],
            $parms["add"]
        );

        return($ret);
    }

}

function smarty_block_rewrite($parms, $content, &$smarty, &$repeat ) {

    if( $repeat ) {

        $get = $_GET;

        $delim = ",";
        if( isset( $parms['delimiter'] ) ) {
            $delim = $parms['delimiter'];
            unset( $parms['delimiter'] );
        }

        foreach( $parms as $k => $v ) {
            if( $k == 'erase' ) {
                $erase = explode($delim, $v);
                foreach( $erase as $to_erase ) {
                    if( isset( $get[$to_erase] ) ) unset( $get[$to_erase] );
                }
            } elseif( $k == 'toggle' ) {
                $toggle = explode($delim, $v);
                foreach( $toggle as $to_toggle ) {

                    // only toggle if sort = country ?
                    if( $get['sort'] == $parms['sort'] ) {
                        if( isset( $get[$to_toggle] ) ) {
                            unset( $get[$to_toggle] );
                        } else {
                            $get[$to_toggle] = '';
                        }
                    }
                }
            } elseif( $k == 'inject' ) {
                // for variable keys
                $inject = $v;
            } else {
                // ignore key as worthless
                if( isset( $inject ) ) {
                    $get[$inject] = $v;
                } else {
                    $get[$k] = $v;
                }
            }
        }

        $ret = http_build_query( $get );
        $ret = str_replace( "=&", "&", $ret );
        if( substr($ret,-1) == "=" ) $ret = substr($ret,0,-1);

        return( $ret );

    }
}
