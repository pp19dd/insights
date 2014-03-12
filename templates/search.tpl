{extends file='template.tpl'}


{block name='content'}

{include file="home_menu.tpl"}

<h1>Search: {$smarty.get.keywords|default:"(Empty search string)"}</h1>

<p>{$entries|count} result{if $entries|count != 1}s{/if}.</p>

{include file="table_entries.tpl" ids=$entries|array_keys entries=$entries}

{/block}
