{extends file="template.tpl"}

{block name="head" append}
<style type="text/css">
.search_boxlet { display: none }
</style>
{/block}

{block name="footer"}
{include file="modal_filter.tpl"}
<script>
$(document).ready(function() {
	var e = $("#search_form_search");
	var e2 = e[0];
	e2.focus();
	e2.selectionStart = e.val().length;

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
