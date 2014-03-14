<?php

// four possible ranges
//    day     (1 day)
//    week    (sat - sun?)
//    month
//    custom

class Insights_Range_Day {
	var $today;				// used for computing start/end
	var $today_timestamp;	// above, computed after setting

	var $range_start;		// computed (specified if custom)
	var $range_end;			// computed (specified if custom)
	
	var $range_start_human;
	var $range_end_human;

	function beforeCompute() { }
	function computeStart() { }
	function afterCompute() { }
	
	function computeEnd() {
		$this->range_end = strtotime( "+1 day", $this->range_start );
	}
	
	function __construct( $today, $range_start, $range_end ) {
		$this->today = $today;
		$this->today_timestamp = strtotime($this->today );

		$this->range_start = strtotime($range_start);
		$this->range_end = strtotime($range_end);

		$this->beforeCompute();
		$this->computeStart();
		$this->computeEnd();
		
		$this->range_start_human = date("Y-m-d", $this->range_start );
		$this->range_end_human = date("Y-m-d", $this->range_end );
		$this->afterCompute();
	}
}

class Insights_Range_Week extends Insights_Range_Day {
	function computeStart() {
		$this->range_start = strtotime( "last Saturday", $this->today_timestamp );
	}
	function computeEnd() {
		$this->range_end = strtotime( "next Sunday", $this->today_timestamp );
	}
}

class Insights_Range_Month extends Insights_Range_Day {
	function computeStart() {
		$this->range_start = strtotime( "first day of this month", $this->today_timestamp );
	}
	function computeEnd() {
		$this->range_end = strtotime( "last day of this month", $this->today_timestamp );
	}
}

class Insights_Range_Custom extends Insights_Range_Day {
// 	function computeStart() {
// 		$this->range_start = strtotime( "first day of this month", $this->today_timestamp );
// 	}
// 	function computeEnd() {
// 		$this->range_end = strtotime( "last day of this month", $this->today_timestamp );
// 	}
}

# replaces:
#$ts = time();
#if( isset( $_GET['day'] ) ) $ts = strtotime($_GET['day']);
#$ts_tomorrow = strtotime("+1 day", $ts);
#$ts_yesterday = strtotime("-1 day", $ts);

class Insights_Range {
	var $day;
	var $week;
	var $month;
	var $custom;

	function __construct( $today, $range_start, $range_end ) {
		$this->day = 	new Insights_Range_Day( $today, $range_start, $range_end );
		$this->week = 	new Insights_Range_Week( $today, $range_start, $range_end );
		$this->month = 	new Insights_Range_Month( $today, $range_start, $range_end );
		$this->custom = new Insights_Range_Custom( $today, $range_start, $range_end );
	}
}
