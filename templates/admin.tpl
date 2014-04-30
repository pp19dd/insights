{extends file='template.tpl'}

{block name='head'}
<style>
.row_count_0 { display: none; }
label { cursor: pointer; }

th.th_id, td.td_id { text-align: right; color: silver; }
th.th_count, td.td_count { text-align: right; width: 100px; }
 
</style>
{/block}

{block name='footer'}

{include file="modal_rename.tpl"}
{include file="modal_merge.tpl"}

<script>

function do_rename_term() {
	var term_id = $("#renameModal_term_id").text();
	var term_name = $("#renameModal_term_name_new").val();
	var term_type = $("#renameModal_term_type").text();

	$("#renameModal_button_close,#renameModal_button_rename").attr("disabled", true);

	$.ajax({
		type: "POST",
		url: "?{rewrite}{/rewrite}",
		data: {
			ajax: true,
			action: 'rename',
			term_id: term_id,
			term_type: term_type,
			term_name: term_name
		},
		success: function(data) {
			$("#renameModal_alert").addClass("alert-info").html( data.out );
			$("#renameModal_button_close,#renameModal_button_rename").attr("disabled", false );

			// update row with what was saved
			$("tr.row_id_" + data.term_id + " .td_name").html( data.term_name );
			$("#renameModal").modal("hide");
		},
		dataType: "json"
	}).fail( function() {
		$("#renameModal_alert").addClass("alert-danger").html( "Error updating record." );
		$("#renameModal_button_close,#renameModal_button_rename").attr("disabled", false );
	});
	
}

function rename_term( term_id, that, term_type ) {
	// reset conditions
	$("#renameModal_alert").removeClass("alert-danger").removeClass("alert-info");
	$("#renameModal_button_close,#renameModal_button_rename").attr("disabled", false);

	// fill in info related to this term_id	
	var term_name = $("tr.row_id_" + term_id + " .td_name").text();
	$("#renameModal_term_name_new").val( term_name );
	$("#renameModal_term_id").html( term_id );
	$("#renameModal_term_type").html( term_type );
	$("#renameModal_term_name").html( term_name );

	$("#renameModal").modal("show");
}

var filters = {
	show_empty: false,
	name: ""
};

function filter_same( filters, old_filters ) {
	var ret = true;

	for( var k in filters )(function(k,v) {
		if( typeof old_filters[k] == "undefined" ) {
			ret = false;
		} else {
			if( old_filters[k] != v ) ret = false;
		} 
	})(k, filters[k]);

	return( ret );
}


function apply_filters() {

	$("#sortable_admin_table tbody tr").each( function(i,e) {
		var hide_count = 0;

		// process the search string as a compound
		// with negation as a word prefix

		var actual_filters = filters.name.trim().split(" ");
		for( i = 0; i < actual_filters.length; i++ )(function(filter) {
			
			var invert = false;
			if( filter.substr(0,1) == "-" ) {
				filter = filter.substr(1);
				invert = true;
			}

			var row_name = $("td.td_name", $(e)).text().toLowerCase();
			var p = row_name.indexOf(filter);

			if( invert == false ) {
				if( p == -1 ) hide_count++;
			} else {
				if( p != -1 ) hide_count++;
			}

		})(actual_filters[i]);

		// show empty rows?
		var row_count = parseInt($("td.td_count", $(e)).text().toLowerCase());
		if( filters.show_empty == false && row_count == 0 ) hide_count++;

		// apply hide rules
		if( hide_count == 0 ) {
			$(e).show();
		} else {
			$(e).hide();
		}
	});

}

// apply filter if needed
$("#filter_name, #filter_empty").bind("click change keydown keyup keypress", function() {
	var old_filters = {};	

	for( var k in filters )(function(k,v) {
		old_filters[k] = v;
	})(k, filters[k]);

	filters.show_empty = $("#filter_empty")[0].checked;
	filters.name = $("#filter_name").val().toLowerCase();

	if( filter_same(filters, old_filters) == false ) {	
		apply_filters();
	}
});


// clear checked merge items
function clear_merge_terms() {
	$(".merge:checked").attr("checked", false);
	merge_count();
}

// merge items

function do_merge_terms() {
	
	var term_type = list;	
	var terms_to_merge = [];
	var reassign_to = parseInt($(".merge_destination").text());

	$(".merge").each( function(i,e) {
		var row_id = $(e).attr("record-id");
		if( e.checked == true && row_id != reassign_to ) terms_to_merge.push( row_id );
	});

	$.ajax({
		type: "POST",
		url: "?{rewrite}{/rewrite}",
		data: {
			ajax: true,
			action: 'merge',
			terms_to_merge: terms_to_merge,
			term_type: term_type,
			reassign_to: reassign_to
		},
		success: function(data) {
			$("#merge_debug").html( data.html );
			$("#mergeModal").modal("hide");

			// hide rows that were merged after setting their counts to 0
			var total_count_to_add = 0;
			for( i = 0; i < terms_to_merge.length; i++ ) {
				var id = terms_to_merge[i];
				var old_count = parseInt($(".row_id_" + id + " .td_count").text());
				total_count_to_add += old_count;
 
				$(".row_id_" + id + " .td_count").html( "0" );

// 				console.log( i, id, old_count, total_count_to_add );
			}

			// update totals
			var total_count = parseInt($(".row_id_" + reassign_to + " .td_count").text());
			var new_count = total_count + total_count_to_add;
			$(".row_id_" + reassign_to + " .td_count").html( new_count );  

// 			console.log( total_count, new_count );

			// hide any records?
			apply_filters();

			// uncheck all items
			clear_merge_terms();
		},
		dataType: "json"
	}).fail( function() {
		$("#merge_debug").html( "Error - unable to merge records." );
	});

}

function merge_items() {

	// reset dialog
	$("#mergeModal_button_rename").attr("disabled", true);

	$(".merge_selection_status").html("&nbsp;");

	var merge_html = 
		"<table class='merge_table' border='0'>" + 
			"<tr>" +
				"<th style='text-align:right; width:35px'>id</th>" + 
				"<th>name</th>" + 
				"<th style='width:35px'>count</th>" + 
				"<th style='text-align:right'>Set all to this name/id</th>" + 
			"</tr>";

	$(".merge").each( function(i,e) {
		var row_id = $(e).attr("record-id");
		var name = $(".row_id_" + row_id + " .td_name").text();
		var count = $(".row_id_" + row_id + " .td_count").text();

		if( e.checked == true ) {
			merge_html += 
				"<tr class='merge_row merge_row_" + row_id + "'>" + 
					"<td style='text-align:right'>" + row_id + "</td>" + 
					"<td>" + name + "</td>" +
					"<td style='text-align:right'>" + count + "</td>" +
					"<td style='text-align:right'>" +
						"<input type='radio' record-id='" + row_id + "' class='merge_reassign' name='merge_reassign' />" + 
					"</td>"
				"</tr>";
		}
	});

	merge_html += "</table>";

	$("#merge_body").html( merge_html );

	$("#merge_body .merge_reassign").click( function() {
		$("#mergeModal_button_rename").attr("disabled", false);
		var row_id = $(this).attr("record-id");
		
		$(".merge_row").removeClass( "merge_row_selected" );
		$(".merge_row_" + row_id).addClass( "merge_row_selected" );

		$(".merge_selection_status").html("All items will be re-assigned to ID #: <span class='merge_destination'>...</span>");
		$(".merge_destination").html( row_id );
	});

	$("#mergeModal").modal("show");
}

function merge_count() {
	var merge_count = 0;
	$(".merge").each( function(i,e) {
		if( e.checked == true ) merge_count++;
	});
	$("#merge_count").html( merge_count );
}

$(".merge").bind("click change", function() {
	merge_count();
});

// $("#filter_name").val( "henry" ).click(); /* debug merge */
// $("tr.admin_row:visible .merge").click() /* debug merge */ 

// start
$("#filter_name").focus();
apply_filters();

</script>

{/block}

{block name='content'}

{include file='admin__menu.tpl'}

<div class="row">


</div>

{/block}
