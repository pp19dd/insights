<?php

# har, stripslashes
class deal_with_slashes {

    function recursive_stripslashes($a) {
        $b = array();
        foreach( $a as $k => $v ) {
            $k = stripslashes($k);
            if( is_array($v) ) {
                $b[$k] = $this->recursive_stripslashes($v);
            } else {
                $b[$k] = stripslashes($v);
            }
        }
        return($b);
    }

    function forceClean() {
        $_POST = $this->recursive_stripslashes( $_POST );
        $_GET = $this->recursive_stripslashes( $_GET );
    }

    function check_magic_quotes() {
        if( get_magic_quotes_gpc() ) {
            $this->forceClean();
        }
    }

    function Clean() {
        $this->check_magic_quotes();
    }

}
