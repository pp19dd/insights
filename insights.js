
function ymd( e ) {
	function pad( n ) {
		return( (n <= 9 ? '0' : '' ) + n);
	}
	var y = parseInt(e.getFullYear());
	var m = parseInt(e.getMonth() + 1);
	var d = parseInt(e.getDate());

	return( y + "-" + pad(m) + "-" + pad(d) );
}

var rainbow = new Rainbow();
rainbow.setNumberRange(0, insights_data.activity.range.max);
rainbow.setSpectrum('#e6e6e6', '#FF8000', '#DC143C');
var rainbow_rules = [];
var rainbow_rule_exists = {};
for( k in insights_data.activity.list )(function(k,v){
	var hexColour = rainbow.colourAt(v);

	if( typeof rainbow_rule_exists[v] == 'undefined' ) {
		rainbow_rule_exists[v] = true;
		rainbow_rules.push(
			".today_" + v + " { background-color: #" + hexColour + " !important; color: white !important }"
		);
	}
})(k, insights_data.activity.list[k]);
$("<style type='text/css'>" + rainbow_rules.join("\n") + "</style>").appendTo("head");

function add_insight() {
	$('#id_add_entry').slideToggle('fast');
	$('#input_deadline').datepicker('hide');
}

$('#pick_add_insight').click( function() { add_insight(); });

$('#id_cancel_new_insight').click( function() {	$('#id_add_entry').slideToggle('fast'); });
$('#id_submit_new_insight').click( function() { });

$('#input_deadline,#entry_deadline').datepicker({

}).on('changeDate', function(e) {
	$(this).datepicker('hide');
});


// range buttons (from, until)
$('.pick_date').datepicker({
	onRender: function(e) {
		if( typeof insights_data.activity.list[ymd(e)] != 'undefined' ) {
			var cal_css_class = 'today_' + insights_data.activity.list[ymd(e)];
			return( cal_css_class );
		}
		return( '' );
	}
}).on('show', function(e) {
	$(".dropdown-menu").css({
		'margin-left': '-118px'
	});
	$(".dropdown-menu .active").removeClass("active").addClass("pseudo-active");
}).on('changeDate', function(e) {
	$("#id_go_button").addClass("active");
	$(".display_date", this).html(ymd(e.date));
	$(this).datepicker('hide');
});

$("#id_go_button").click(function() {
	var from = $("#id_range_from").text();
	var until = $("#id_range_until").text();
	var url = $("#id_go_button").attr( "url" );
	window.open( url + "&day=" + from + "&until=" + until, "_self" );
});

// delete buttons are two-step
$(".deletion_button").click( function() {
	if( $(this).hasClass( "btn-danger" ) ) {
		// confirm deleting
		var id = $(this).attr( 'record-id' );
		var deletion_target = $(this).attr( 'deletion-target' );
		window.open( deletion_target, '_self' );
	} else {
		$(".deletion_button").removeClass( 'btn-danger' ).html( "Delete" );
		$(this).addClass( 'btn-danger' ).html( "Really?") ;
	}
});

// these have inline values
$('.parse_select2').each( function(i,e) {
	var cc = $(e).attr("data-can-clear");

	var select_parms = { separator: ";" }
	if( $(e).hasClass("select2_fixed_width") ) {
		select_parms["width"] = "resolve";
	}

	if( typeof cc != "undefined" ) {
		select_parms["allowClear"] = true;
	}

	$(e).select2(select_parms);

});

// data and preloads are stored/referenced in attrs
$('.parse_select2b').each( function(i,e) {

	// used for both stages
	var cc = $(e).attr("data-can-clear");
	var t = $(e).attr("data-selected");
	var data_key = $(e).attr("insights_data");

	// stage 1: pipe to data source
	$(e).select2({
		separator: ";",
		data: insights_data[data_key],
		createSearchChoice: function(term, data) {
			var f = $(data).filter( function() {
				return( this.text.localeCompare(term) === 0 );
			});

			if( f.length === 0 ) {
				return({ id:term, text:term });
			}
		},
		allowClear: true,
		multiple: true
	});

	// stage 2: populate tag-like select box with values
	if( (typeof t == 'string') && t.length > 0 ) {
		var values = t.split(",");
		var values_obj = [];

		for( value in values ) {
			var stored_id = parseInt( values[value] );

			var temp = $.grep(insights_data[data_key].results, function(e ) {
				if( e.id == stored_id ) return( true );
				return( false );
			});

			values_obj.push({
				"id": stored_id,
				"text": temp[0].text
			});
		}

		$(e).select2( "data", values_obj );
	}
});

// escape key shortcut to add new insight
$(document).keyup(function(e) {
	if( e.keyCode == 27 ) {
		$('#id_add_entry').slideToggle('fast');
		$('#input_deadline').datepicker('hide');
	}
});

$("#admin_login").click( function() {
	return( false );
});

$(document).ready( function() {

	$(".hold_for_release_checkbox").click( function() {

		var parent = $(this).attr("parent");
		var actual_parent = $("#" + parent);

		if( this.checked ) {
			actual_parent.hide("slide");
		} else {
			actual_parent.show("slide");
		}
	}).each( function() {
		if( this.checked ) $("#id_entry_form_group_deadline").hide("slide");
	});

	var data_table = new filterable_table();

	data_table.init({
		selector: "#table_filterable",
		cookie_name: "insights_columns",
		columns: {
			slug: 	true,	description:	true,	deadline: 	true,
			origin: true,	medium: 		true,	beat: 		true,
			region: true,	reporter: 		true,	editor: 	true
		},
		modal: "#filterModal",
		anchor: "h1.table_title",
		filter_container: "#filterModal .filter_container",
		cancel: "#filterModal_button_close"
	});

	var insights_watchlist = new watchlist();
	insights_watchlist.init();

	$("#search_form_search").focus();
	
});

//isotope is fighting bootstrap, table for now
//	var $container = $('#grouped_entries');
//
//	$container.isotope("layout");
//	$container.isotope({
//		itemSelector: '.derp',
//		layoutMode: 'fitRows'
//	});
//});

//add_calendar_legend();

//debug	add_insight();
//debug	$("#pick_date").click();
//debug	$(".changelog_toggler").click();
