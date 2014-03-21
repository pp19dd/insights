{extends file='template.tpl'}


{block name='content'}

{include file="home_menu.tpl"}

<h1>Search: {$smarty.get.keywords|default:"(Empty search string)"}</h1>

<ul>
{foreach from=$search_tips key=word item=alt}
	<li>{$word} <a title="Remove word from search" href="?{rewrite keywords=$alt}{/rewrite}">[Remove]</a></li>
{/foreach}
</ul>

<p>{$entries|count} result{if $entries|count != 1}s{/if}.</p>

{if $search_tips|count == 0}
<p><a href="?{rewrite erase='keywords,search'}{/rewrite}">Remove Search</a></p>
{/if}


{include file="table_entries.tpl" ids=$entries|array_keys entries=$entries}

{/block}
