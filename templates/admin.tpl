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

<!-- Modal -->
<div class="modal fade" id="renameModal" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
	<div class="modal-dialog">
		<div class="modal-content">
			<div class="modal-header">
				<button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
				<h4 class="modal-title" id="myModalLabel">Rename this term?</h4>
			</div>
			<div class="modal-body">
				<ul>
					<li>Term id: <span id="renameModal_term_id"></span></li>
					<li>Term type: <span id="renameModal_term_type"></span></li>
					<li>Term name: <span id="renameModal_term_name"></span></li>
				</ul>

				New name: <input id="renameModal_term_name_new" type="text" autocomplete="off" style="width:300px" />
			</div>
			<div class="modal-footer">
				<div class="pull-left alert" id="renameModal_alert"></div>
				<button type="button" id="renameModal_button_close" class="btn btn-default" data-dismiss="modal">Close</button>
				<button type="button" id="renameModal_button_rename" class="btn btn-primary" onclick="do_rename_term()">Rename</button>
			</div>
		</div>
	</div>
</div>

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

	// fill in info related ot this term_id	
	var term_name = $("tr.row_id_" + term_id + " .td_name").text();
	$("#renameModal_term_name_new").val( term_name );
	$("#renameModal_term_id").html( term_id );
	$("#renameModal_term_type").html( term_type );
	$("#renameModal_term_name").html( term_name );

	$("#renameModal").modal("show");
}

var filters = {
	show_empty: false,
	name_invert: false,
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

		// partial name match
		var row_name = $("td.td_name", $(e)).text().toLowerCase();
		var p = row_name.indexOf(filters.name);
		
		if( filters.name_invert == false ) {
			if( p == -1 ) hide_count++;
		} else {
			if( p != -1 ) hide_count++;
		}
		
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
$("#filter_name, #filter_empty, #filter_name_invert").bind("click change keydown keyup keypress", function() {
	var old_filters = {};	

	for( var k in filters )(function(k,v) {
		old_filters[k] = v;
	})(k, filters[k]);

	filters.show_empty = $("#filter_empty")[0].checked;
	filters.name_invert = $("#filter_name_invert")[0].checked;
	filters.name = $("#filter_name").val();

	if( filter_same(filters, old_filters) == false ) {	
		apply_filters();
	}
});


$("#filter_name").focus();
apply_filters();

</script>

{/block}

{block name='content'}

{include file='admin__menu.tpl'}

<div class="row">


</div>

{/block}
