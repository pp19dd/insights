<?php

class Rewrite_URL {
	
	var $url = "";
	var $frag;
	var $get = array();
	
	function __construct($url = null) {
		$this->url = $url;
		if( is_null($url) ) $this->url = $_SERVER['REQUEST_URI'];
		
		$this->frag = parse_url($this->url);
		$this->split_parts();
	}
	
	public function __toString() {
		return( $this->GetURL() );
	}
	
	function split_parts() {
		if( !isset( $this->frag["query"])) return;
		
		$e_arr = explode("&", $this->frag["query"]);
		foreach( $e_arr as $e ) {
			$p = explode("=", $e);
			if( count($p) == 2 ) {
				$this->set( urldecode($p[0]), urldecode($p[1]) );
			} elseif( count($p) == 1 ) {
				$this->set( urldecode($p[0]) );
			}
		}
	}
	
	function set( $parm, $value = null ) {
		$this->get[$parm] = $value;
	}
	
	function erase( $parm ) {
		if( !isset($this->get[$parm]) ) return;
		unset( $this->get[$parm] );
	}
	
	function GetURL() {
		$a = array();
		foreach( $this->get as $k => $v ) {
			if( is_null($v)) {
				$a[] = urlencode($k);
			} else {
				$a[] = urlencode($k) . "=" . urlencode($v);
			}
		}
		return( "?" . implode("&", $a) );
	}
}
