{extends file="template.tpl"}

{block name="head" append}
<style type="text/css">
.search_boxlet { display: none }
</style>
{/block}

{block name="footer"}
{include file="modal_filter.tpl"}

<script>
var search = {$highlight|json_encode};

function highlight_search_terms() {
	$("td.highlightable").highlight( search.highlight );
	/*$("td.highlightable").each(function(i,e) {
		var original = $(e).html();
		for( var word in search.highlight ) {
			original = original.replace(
				word,
				"<span class='highlight'>" + word + "</span>"
			);
		}
		$(e).html( original );
		console.info( );
	});*/
	//console.info( "HIGHLIGHT" );
	//console.dir( search.highlight );
}

function cursor_in_search_field() {
	var e = $("#search_form_search");
	var e2 = e[0];
	e2.focus();
	e2.selectionStart = e.val().length;
}

// cursor in search field
$(document).ready(function() {
	cursor_in_search_field();
	// highlight_search_terms();
});
</script>
{/block}

{block name="content"}

{include file="home_menu.tpl"}

{if isset($elasticsearch_results)}
	{include file="search_elastic.tpl"}
{else}
	{include file="search_classic.tpl"}
{/if}

{/block}
