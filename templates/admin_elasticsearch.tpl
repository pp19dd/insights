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

<table class="tbl_elasticsearch_status">
<tr><td>&nbsp;</td></tr>
{esbutton label="Records" action="records" icon="refresh" verify="no"}
{esbutton label="Status" action="status" icon="refresh" verify="no"}
<tr><td>&nbsp;</td></tr>
{esbutton label="Create Index" action="create_index" icon="ok" verify="yes"}
{esbutton label="Delete Index" action="delete_index" icon="remove" verify="yes"}
{esbutton label="Bulk Insert" action="bulk_insert" icon="barcode" verify="yes"}
<tr><td colspan="2"><hr/></td></tr>
<tr>
	<td style="width:170px">

		<p>JSON query:</p>

{function name="esradio"}

<input {if isset($checked)}checked="checked"{/if} id="id_{$ename}" type="radio" name="es_radio" value="{$ename}" />
<label for="id_{$ename}"> {$ename}</label><br/>

{/function}

{esradio ename="print_r"}
{esradio ename="print_r | hits"}
{esradio checked=true ename="table"}
{esradio ename="console"}

	</td>
<td>
<textarea id="elasticsearch_query_textarea">{
    "query" : {
        "match" : {
            "description" : {
                 "query": "rotations",
                 "operator": "and"
            }
        }
    }
}
</textarea>
</td>
</tr>
{esbutton label="Query (CTRL+Enter)" action="query" icon="search" verify="no"}

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

$("#elasticsearch_query_textarea").keydown(function(e) {
	if( (e.keyCode == 10 || e.keyCode == 13) && e.ctrlKey ) {	
		elasticsearch_admin("query");
	}
});

function clear_button(e) {
	$(e).removeClass( "btn-danger");
	var label = $(e).attr("original-label");
	$(e).find(".actual_label").html(label);
}

function clear_all_buttons() {
	$(".elasticsearch_button").each( function(i,e) {
		clear_button(e);
	});
}

// delete buttons are two-step
$(".elasticsearch_button").click( function() {

	// mostly status ...
	var verify = $(this).attr("verify");
	var action = $(this).attr("original-action");

	if( verify == "no" ) {
		clear_all_buttons();
		elasticsearch_admin(action);
		return(false);
	}

	if( $(this).hasClass( "btn-danger" ) ) {
		
		// confirm deleting
		
		clear_button(this);
		
		elasticsearch_admin(action);

	} else {
		clear_all_buttons();

		$(this).addClass( 'btn-danger' );
		$(this).find(".actual_label").html( "Really?") ;

	}
});



//elasticsearch_status();
</script>
{/block}
