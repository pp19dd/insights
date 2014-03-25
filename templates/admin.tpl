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

<script>
function toggle_hidden(that) {
	if( that.checked == true ) {
		$('.row_count_0').show();
	} else {
		$('.row_count_0').hide();
	}
	$.cookie("admin_show_empty_rows", (that.checked == true ? 'true' : 'false' ), { expires: 365 } );
}

if( typeof $.cookie("admin_show_empty_rows") != 'undefined' ) {
	
	if( $.cookie("admin_show_empty_rows") == "true" ) {
		$('.row_count_0').show();
		$("#show_empty_rows").attr( "checked", true );
	}
}

function filter_name() {
	var name = $("#filter_name").val().toLowerCase();

	$("#sortable_admin_table tr").each( function(i,e) {
		var row_name = $("td.td_name", $(e)).text().toLowerCase();
		var p = row_name.indexOf(name);
		if( p == -1 ) {
			$(e).hide(); 
		} else {
			$(e).show();
		}
	});
}

$("#filter_name").change( function() {
	filter_name();
}).keydown( function() {
	filter_name();
}).keyup( function() {
	filter_name();
}).keypress( function() {
	filter_name();
});

</script>

{/block}

{block name='content'}

{include file='admin__menu.tpl'}

<div class="row">


</div>

{/block}
