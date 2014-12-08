{extends file='admin.tpl'}

{block name='content' append}

<h1>Search Engine</h1>



{function name=esbutton}
<tr>
<td>
<div class="btn-group btn-elasticsearch">
	<a type="button" original-label="{$label}" class="btn btn-default btn-sm elasticsearch_button" verify="{$verify}" original-action="{$action}">
		<span class="glyphicon glyphicon-{$icon}"></span>
		<span class="actual_label">{$label}</span>
	</a>
</div>
</td>
	<td><div id="{$action}">...</div></td>
</tr>

{/function}

<table>
{esbutton label="Records" action="records" icon="refresh" verify="no"}
{esbutton label="Status" action="status" icon="refresh" verify="no"}
<tr><td>&nbsp;</td></tr>
{esbutton label="Create Index" action="create_index" icon="ok" verify="yes"}
{esbutton label="Delete Index" action="delete_index" icon="remove" verify="yes"}
{esbutton label="Bulk Insert" action="bulk_insert" icon="barcode" verify="yes"}
</table>

<hr/>

<p>Notes:</p>
<ul>
	<li>Do not use this function if you don't fully understand its implications.</li>
	<li>Always make sure search engine is running, by clicking status. Count should be in thousands.</li>
	<li>If status count is blank, perform: create an index.</li>
	<li>If status count is zero, perform: bulk insert.</li>
	<li>Bulk insertion may take several minutes.</li>
</ul>

{*
{include file='admin__table.tpl' list='cameras' table_title='Cameras' add=false editable=false hide=array('is_deleted') data=$cameras}
*}

{*
{include file="table_entries.tpl" ids=$cameras|array_keys entries=$cameras custom_edit_link=true}
*}

{/block}


{block name="footer" append}
<script>

function clear_button(e) {
	$(e).removeClass( "btn-danger");
	var label = $(e).attr("original-label");
	$(e).find(".actual_label").html(label);
}

// delete buttons are two-step
$(".elasticsearch_button").click( function() {

	// mostly status ...
	var verify = $(this).attr("verify");
	var action = $(this).attr("original-action");

	if( verify == "no" ) {
		elasticsearch_admin(action);
		return(false);
	}

	if( $(this).hasClass( "btn-danger" ) ) {
		
		// confirm deleting
		
		clear_button(this);
		
		elasticsearch_admin(action);

	} else {
		$(".elasticsearch_button").each( function(i,e) {
			clear_button(e);
		});
		
		$(this).addClass( 'btn-danger' );
		$(this).find(".actual_label").html( "Really?") ;

	}
});



//elasticsearch_status();
</script>
{/block}
