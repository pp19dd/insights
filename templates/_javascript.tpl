
<script type="text/javascript">

function ymd( e ) {
	function pad( n ) {
		return( (n <= 9 ? '0' : '' ) + n);
	}
	var y = parseInt(e.getFullYear());
	var m = parseInt(e.getMonth() + 1);
	var d = parseInt(e.getDate());
	
	return( y + "-" + pad(m) + "-" + pad(d) );
}

var insights_data = {
	editors: { results: {$editors_reduced|json_encode} },
	reporters: { results: {$reporters_reduced|json_encode} },
	activity: {$activity|json_encode},
	entry: {if isset($entry)}{$entry|json_encode}{else}null{/if}
};

var rainbow = new Rainbow();
rainbow.setNumberRange(0, insights_data.activity.range.max);
rainbow.setSpectrum('#e6e6e6', '#FF8000', '#DC143C');
var rainbow_rules = [];
for( k in insights_data.activity.list )(function(k,v){
	var hexColour = rainbow.colourAt(v);
	rainbow_rules.push(
		".today_" + v + " { background-color: #" + hexColour + " !important; }"
	);
})(k, insights_data.activity.list[k]);
$("<style type='text/css'>" + rainbow_rules.join("\n") + "</style>").appendTo("head");

function add_calendar_legend() {
	var spans = [];
	var segs = 5;

	for( i = 0; i < segs; i++ ) {
		var l = (i) * (insights_data.activity.range.max / segs);
		var u = (i+1) * (insights_data.activity.range.max / segs);
		var v = (i+1) * (insights_data.activity.range.max / segs);
		var tx = l + "-" + u; 
		spans.push(
			"<span style='background-color:#" + rainbow.colourAt(v) + "'>" + tx + "</span>"
		);
	}

	$(".datepicker.dropdown-menu").append(
		"<div style='clear:both; margin-top:5px; height:15px; display:block' class='cal_legend'>" +
			spans.join( "\n" ) +
			"<span style='font-size:10px'> Entries</span>" +
			//"<span class='cal_due'>Due</span>" +
			//"<span class='cal_started'>Started</span>" +
		"</div>"
	);

}


function add_insight() {
	$('#id_add_entry').slideToggle('fast');
	$('#input_deadline').datepicker('hide');
}

$('#pick_add_insight').click( function() { add_insight(); });
$('#pick_date_prev').click( function() { window.open( '?{rewrite day=$yesterday erase=edit}{/rewrite}', '_self' ); });
// $('#pick_date_today').click( function() { window.open( '?', '_self' ); });
$('#pick_date_next').click( function() { window.open( '?{rewrite day=$tomorrow erase=edit}{/rewrite}', '_self' ); });
$('#id_cancel_new_insight').click( function() {	$('#id_add_entry').slideToggle('fast'); });
$('#id_submit_new_insight').click( function() { });

$('#input_deadline').datepicker({
}).on('changeDate', function(e) {
	$(this).datepicker('hide');
});

$('#entry_deadline').datepicker({

/*}).on('changeDate', function(e) {
	$(this).datepicker('hide');
*/	
});



$('#pick_date').datepicker({
	onRender: function(e) {
		// if( ymd(e) == '{$actually_today}' ) return( 'today' );
		
		if( typeof insights_data.activity.list[ymd(e)] != 'undefined' ) {
			var cal_css_class = 'today_' + insights_data.activity.list[ymd(e)];
			return( cal_css_class );
		}
		
		return( '' );
	}
}).on('show', function(e) {
	// add_calendar_legend();
	/*
	$(".dropdown-menu").css({
		'margin-left': '-118px'
	});
	*/
	$(".dropdown-menu .active").removeClass("active").addClass("pseudo-active");
}).on('changeDate', function(e) {
	$('#pick_date').datepicker('hide');
	window.open( '?day=' + ymd(e.date), '_self' );
});

// delete buttons are two-step
$(".deletion_button").click( function() {
	if( $(this).hasClass( "btn-danger" ) ) {
		// confirm deleting
		var id = $(this).attr( 'record-id' );
		window.open( '?delete=' + id, '_self' );
	} else {
		$(".deletion_button").removeClass( 'btn-danger' ).html( "Delete" );
		$(this).addClass( 'btn-danger' ).html( "Really?") ;
	}
});

// these have inline values
$('.parse_select2').select2();

// data and preloads are stored/referenced in attrs
$('.parse_select2b').each( function(i,e) {
	
	// used for both stages
	var t = $(e).attr("data-selected");
	var data_key = $(e).attr("insights_data");

	// stage 1: pipe to data source
	$(e).select2({
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

// add_calendar_legend();

// debug	add_insight();
// debug	$("#pick_date").click();
</script>

