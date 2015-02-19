{function name="pagination"}

{if $pages.page_count > 1}
<ul class="pagination">
	<li style="color:black; border:0px;">
		<a style="border:0px;">{$elasticsearch_results.exact.hits.total} result{if $elasticsearch_results.exact.hits.total != 1}s{/if}</a>

	</li>
	<li class="">
{if $pages.current > 1}
		<a href="?{rewrite p=$pages.current-1}{/rewrite}">&lt;</a>
{else}
		<a style="color: black" href="#">&nbsp;</a>
{/if}
	</li>
{*<!--
{foreach from=$pages.pages item=p}
	<li class="{if $p == $pages.current}active{/if}"><a href="?{rewrite p=$p}{/rewrite}" title="Page {$p}">{$p}</a></li>
{/foreach}
-->*}
	<li><a>Page {$pages.current} of {$pages.pages|count}</a></li>
	<li class="">
{if $pages.current < $pages.pages|count}
		<a href="?{rewrite p=$pages.current+1}{/rewrite}">&gt;</a>
{else}
	<a style="color: black">&nbsp;</a>
{/if}
	</li>
</ul>
{else}
<h1>{$elasticsearch_results.exact.hits.total} result{if $elasticsearch_results.exact.hits.total != 1}s{/if}</h1>
{/if}

{/function}

<div class="clearfix"></div>

{pagination}

<div class="clearfix"></div>

{if $entries|count == 0}

<p>No results found, but you can do the following:</p>
<ul>
	<li><a href="{$base_url}">Start Over</a></li>
	<li>Remove some search terms:

<ul class="search_tips">
	{foreach from=$search_tips key=word item=alt}
	<li class="search_term">{$word} <a class="glyphicon glyphicon-remove" title="Remove word from search" href="?{rewrite erase='deleted,p' keywords=$alt}{/rewrite}"></a></li>
	{/foreach}
</ul>

	</li>
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

{pagination}

{/if}
