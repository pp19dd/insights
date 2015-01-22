
<form class="" action="http://localhost/insights/?" method="get">
<table width="100%">
	<tr>
		<td style="width:100px">Keywords</td>
		<td><input type="text" autocomplete="off" name="keywords" id="search_form_search" value="{$smarty.get.keywords}"></td>
		<td style="width:100px"><input type="submit" value="Search" name="search" style="margin-right:10px"></td>
	</tr>
	<tr>
		<td>Refinement</td>
		<td colspan="2">
			<ul class="search_tips">
				{foreach from=$search_tips key=word item=alt}
				<li class="search_term">{$word} <a class="glyphicon glyphicon-remove" title="Remove word from search" href="?{rewrite erase='deleted,p' keywords=$alt}{/rewrite}"></a></li>
				{/foreach}
			</ul>
		</td>
	</tr>
</table>

</form>


<div class="clearfix"></div>

<h1>{$elasticsearch_results.exact.hits.total} result{if $elasticsearch_results.exact.hits.total != 1}s{/if}</h1>

{if $pages.page_count > 1}
<ul class="pagination">
{foreach from=$pages.pages item=p}
	<li class="{if $p == $pages.current}active{/if}"><a href="?{rewrite p=$p}{/rewrite}" title="Page {$p}">{$p}</a></li>
{/foreach}
</ul>
{/if}

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
