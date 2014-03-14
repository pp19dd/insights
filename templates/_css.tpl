
<style type="text/css">

h1 { font-size: 18px; color: gray }

.insights_show_by_menu .btn { margin-bottom: 0.5em; }

.insights_entry_count { color: silver; font-size:10px; }
.insights_entry_count:before { content: "("; }
.insights_entry_count:after { content: ")"; }
.insights_number_entries { font-size:12px; background-color: black; color: white }

.insights_grid_list_action { width:80px }

.insights_entries { }
.insights_entry { }
.insights_entry a { color: black }
.insights_slug { margin:0px; }
.insights_description { color: silver; font-size: 10px }

.insights_star_note { }
.insights_star_note_starred { color: darkorange }
.insights_star_note_empty { color: lightsteelblue }


.more_view {}
.more_view .insights_entries { line-height: 1.5em }


{*
.voa_insights_top { background-color: black !important }
.voa_insights_top a { color: white !important }
*}

.voa-insights-brand {
	background-image: url({$base_url}img/voa-insights-50.png);
	background-repeat: no-repeat;
	padding-left: 120px;
	background-position: 0px -7px;
}

.left-most { width: 70px }
.right-most { text-align: right; width:200px }

/*
.datepicker-days .today { border:1px dashed blue }
.datepicker-days .active {
	background-color: inherit !important;
	background-image: inherit !important;
}
*/

.pseudo-active { border:1px dashed blue }

/* calendar */
.datepicker-days .disabled { color: silver }
.cal_legend { }
.cal_due { color: red}
.cal_started { color: green }
.day {
	border: 2px solid white;
	border-radius:0px !important;
} 


#id_add_entry {
	background-color: rgb(230,230,230);
	/* box-shadow:0 0 1em rgb(230,230,230); */
	border: 1px solid gray; 
	border-radius:1em;
	padding-top:1em;
	margin-bottom:1em;
	display: none;
}
textarea { resize:vertical }

.select2-container { border:0 }
.deletion_button { width:130px }
.container_add_insight { padding-right: 0px; padding-left: 0px }

/* time field fixes */
.select2-container .select2-choice { height:32px; }
.select2-chosen { margin-top: 3px; }

/* table */
.entry_field { font-size: 12px; }
.entry_slug { }
.entry_description { }
.entry_deadline { }
.entry_services { }
.entry_mediums { }
.entry_beats { }
.entry_regions { }
.entry_reporters { }
.entry_editors { }
.entry_edit { }

/* range helper */

.range { margin-bottom:10px }
.range td { text-align: center; font-size:12px; }
.range_active { background-color: cornflowerblue; color: white }

.insights_range { margin-bottom:1em }

.btn_range { text-align: center }
.btn_range_day { width:100px }
.btn_range_week { width:200px }
.btn_range_month { width:400px }

.btn_range_sm { text-align: center }
.btn_range_day_sm { width:75px }
.btn_range_week_sm { width:150px }
.btn_range_month_sm { width:200px }

.after_range { margin-bottom:20px }

</style>
