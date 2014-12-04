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
	function afterCompute() { }
	
	function computeStart() {
		$this->range_start = $this->today_timestamp;
	}
	
	function computeEnd() {
		// $this->range_end = strtotime( "+1 day", $this->range_start );
		$this->range_end = $this->range_start;
	}
	
	function __construct( $today, $range_start = null, $range_end = null ) {

		// hold for release exception
		// treat HFR as a 'day', today
		if( $today === "HFR" ) $today = "today";
		
		$this->today = $today;
		$this->today_timestamp = strtotime($this->today );

		if( !is_null( $range_start )) $this->range_start = $range_start;
		if( !is_null( $range_end )) $this->range_end = $range_end;
		
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
		// 0 = sun, ... 6 = sat
		$day_of_week = date("w", $this->today_timestamp);
		
		// $this->range_start = strtotime( "sunday this week", $this->today_timestamp );
		$this->range_start = strtotime( "-{$day_of_week} day", $this->today_timestamp);
	}
	function computeEnd() {
		// 0 = sun, ... 6 = sat
		$day_of_week = date("w", $this->today_timestamp);
		$diff = 6 - $day_of_week;
		
		// $this->range_end = strtotime( "saturday this week", $this->today_timestamp );
		$this->range_end = strtotime( "+{$diff} day", $this->today_timestamp);
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
	function computeStart() {
		$this->range_start = strtotime($this->range_start);
	}
	function computeEnd() {
		$this->range_end = strtotime($this->range_end);
	}
}

# replaces:
#$ts = time();
#if( isset( $_GET['day'] ) ) $ts = strtotime($_GET['day']);
#$ts_tomorrow = strtotime("+1 day", $ts);
#$ts_yesterday = strtotime("-1 day", $ts);

class Insights_Range {
	var $actually_today;
	
	var $day;
	var $week;
	var $month;
	var $custom;
	
	function d( $str, $ts ) {
		return( date( "Y-m-d", strtotime($str, $ts) ) );
	}
	
	function __construct( $today = null, $range_start = null, $range_end = null ) {
		$this->actually_today = date("Y-m-d");
		if( is_null( $today )) $today = $this->actually_today;
		
		$this->day = 			new Insights_Range_Day( $today );
		$this->day->prev =  	new Insights_Range_Day( $this->d("-1 day", $this->day->today_timestamp) );
		$this->day->next =  	new Insights_Range_Day( $this->d("+1 day", $this->day->today_timestamp) );
		
		$this->week = 			new Insights_Range_Week( $today );
		$this->week->prev = 	new Insights_Range_Week( $this->d("-7 day", $this->day->today_timestamp) );
		$this->week->next = 	new Insights_Range_Week( $this->d("+7 day", $this->day->today_timestamp) );

		$this->month = 			new Insights_Range_Month( $today );
		$this->month->prev = 	new Insights_Range_Month( $this->d("-1 month", $this->day->today_timestamp ) );
		$this->month->next = 	new Insights_Range_Month( $this->d("+1 month", $this->day->today_timestamp ) );
		
		$this->custom = 		new Insights_Range_Custom( $today, $range_start, $range_end );
	}
}
