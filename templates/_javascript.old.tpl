
<script type="text/javascript">

var insights_data = {
	editors: { results: {$editors_reduced|json_encode} },
	reporters: { results: {$reporters_reduced|json_encode} },
	activity: {$activity|json_encode},
	entry: {$entry|json_encode}
};

function ymd( e ) {
	function pad( n ) {
		return( (n <= 9 ? '0' : '' ) + n);
	}
	var y = parseInt(e.getFullYear());
	var m = parseInt(e.getMonth() + 1);
	var d = parseInt(e.getDate());
	
	return( y + "-" + pad(m) + "-" + pad(d) );
}

function add_insight() {
	$('#id_add_entry').slideToggle('fast');
	$('#input_deadline').datepicker('hide');
}

$('#pick_add_insight').click( function() { add_insight(); });
$('#pick_date_prev').click( function() { window.open( '?day={$yesterday}', '_self' ); });
// $('#pick_date_today').click( function() { window.open( '?', '_self' ); });
$('#pick_date_next').click( function() { window.open( '?day={$tomorrow}', '_self' ); });
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
		if( ymd(e) == '{$actually_today}' ) return( 'today' );
		
		if( typeof insights_data.activity[ymd(e)] != 'undefined' ) {
			return( 'today' );
		}
		
		return( '' );
	}
}).on('show', function(e) {
	$(".dropdown-menu").css({
		'margin-left': '-118px'
	});
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

{*
$('.parse_select2b').select2({
	query: function(query) {
		var insights_key = $(this.element).attr("insights_data");
		query.callback( insights_data[insights_key] );
	},
	createSearchChoice: function(term, data) {
		var f = $(data).filter( function() { return( this.text.localeCompare(term) === 0 ); });
		
		if( f.length === 0 ) {
			return({ id:term, text:term });
		}

		// prune
		/*
		for( obj in insights_data.reporters.results )(function(i, v) {
			if( v.id == v.text ) 
				delete insights_data.reporters.results[obj];
		})(obj, insights_data.reporters.results[obj]);	
		*/
		/*
		*/
	},
	allowClear: true,
	multiple: true
	//data: insights_data[$(this.element).attr("insights_data")["results"]]
});
*}

$('.parse_select2b').select2({
	data: insights_data.reporters,
	createSearchChoice: function(term, data) {
		var f = $(data).filter( function() { return( this.text.localeCompare(term) === 0 ); });
		
		if( f.length === 0 ) {
			return({ id:term, text:term });
		}
	},
	allowClear: true,
	multiple: true
	
	/*query: function( query ) {
		var insights_key = $(this.element).attr("insights_data");
		query.callback( insights_data[insights_key] );
	}*/
});

// edit screen preload
$('.parse_select2b').each( function(i,e) {
	var t = $(e).attr("data-selected");
	var data_key = $(e).attr("insights_data");
	
	// populate tag-like select box with values
	if( (typeof t == 'string') && t.length > 0 ) {
		var values = t.split(",");
		var values_obj = [];
		
		for( value in values ) {
			var stored_id = parseInt( values[value] );
			var temp = $.grep(insights_data[data_key].results, function(e ) {
				if( e.id == stored_id ) return( true );
				return( false );
			})
			values_obj.push({
				"id": stored_id,
				"text": temp[0].text
			});
		}
		
		$(e).select2( "data", values_obj );
	}
});
{*
*}

$(document).keyup(function(e) {
	if( e.keyCode == 27 ) {
		$('#id_add_entry').slideToggle('fast');
		$('#input_deadline').datepicker('hide');
	}
});

function edit(d) {
	add_insight();
	
	$("#input_slug").val( d.slug );
	$("#input_description").val( d.description );
	
	// medium - r - t - w
	$("#input_deadline").datepicker('setValue', d.deadline );
	
	// origin
	// reporter
	// editor
	// beats
	// regions
	
}

{*
/*
{if $smarty.get.edit}

edit( insights_data.entry );

{/if}
*/
*}

/*
$(".datepicker.dropdown-menu").append(
	"<p class='cal_legend'>" +
		"<span class='cal_due'>Due</span>" +
		"<span class='cal_started'>Started</span>" +
	"</p>"
);
*/

// debug	add_insight();
</script>

