
<h1>Search keywords</h1>

<form class="" action="http://localhost/insights/?" method="get">
<table width="100%">
	<tr>
		<td><input type="text" autocomplete="off" name="keywords" id="search_form_search" value="{$smarty.get.keywords}"></td>
		<td style="width:100px"><input type="submit" value="Search" name="search" style="margin-right:10px"></td>
	</tr>
</table>

</form>

<ul class="search_tips">
{foreach from=$search_tips key=word item=alt}
	<li class="search_term">{$word} <a class="glyphicon glyphicon-remove" title="Remove word from search" href="?{rewrite erase=deleted keywords=$alt}{/rewrite}"></a></li>
{/foreach}
</ul>

<div class="clearfix"></div>

<h1>{$elasticsearch_results.exact.hits.total} result{if $elasticsearch_results.exact.hits.total != 1}s{/if}</h1>

<div class="clearfix"></div>

{if $entries|count == 0}

<p>No results found, but you can do the following:</p>
<ul>
	<li><a href="{$base_url}">Start Over from today</a></li>
	<li>Increase the search date range (currently {$range->active->range_start_human} to {$range->active->range_end_human}).</li>
	<li>Remove some extra search terms.</li>
	<li>Shorten the search terms, or reduce to a common stem (ex: instead of Ukraine try ukr)</li>
</ul>

{else}

{*<!--
{if $range->active->range_start_human == $range->active->range_end_human}
<h1 class="table_title">Search date includes {$range->active->range_start_human|date_format:"M d, Y"}</h1>
{else}
<h1 class="table_title">Search dates include {$range->active->range_start_human|date_format:"M d, Y"} - {$range->active->range_end_human|date_format:"M d, Y"}</h1>
{/if}
-->*}


{include file="table_entries.tpl" ids=$entries|array_keys entries=$entries highlight=$search_tips|array_keys}

{/if}
