
{if $search_tips|count == 0}
<p><a href="?{rewrite erase='keywords,search'}{/rewrite}">Exit from Search Mode</a></p>
{/if}

<h1>Search: {$smarty.get.keywords|default:"(Empty search string)"}</h1>

<ul>
{foreach from=$search_tips key=word item=alt}
	<li>{$word} <a title="Remove word from search" href="?{rewrite keywords=$alt}{/rewrite}">[Remove]</a></li>
{/foreach}
</ul>

{include file="table_entries.tpl" ids=$elasticsearch_results2|array_keys entries=$elasticsearch_results2}

<pre>{$elasticsearch_results2|print_r}</pre>

{if $entries|count == 0}

<p>No results found, but you can do the following:</p>
<ul>
	<li><a href="{$base_url}">Start Over from today</a></li>
	<li>Increase the search date range (currently {$range->active->range_start_human} to {$range->active->range_end_human}).</li>
	<li>Remove some extra search terms.</li>
	<li>Shorten the search terms, or reduce to a common stem (ex: instead of Ukraine try ukr)</li>
</ul>

{else}

<p>{$entries|count} result{if $entries|count != 1}s{/if}.</p>

{if $range->active->range_start_human == $range->active->range_end_human}
<h1 class="table_title">Search date includes {$range->active->range_start_human|date_format:"M d, Y"}</h1>
{else}
<h1 class="table_title">Search dates include {$range->active->range_start_human|date_format:"M d, Y"} - {$range->active->range_end_human|date_format:"M d, Y"}</h1>
{/if}

{include file="table_entries.tpl" ids=$entries|array_keys entries=$entries}

{/if}
