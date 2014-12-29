{extends file='template.tpl'}

{block name='footer'}
{include file="modal_filter.tpl"}
{/block}

{block name='content'}

{include file="home_menu.tpl"}

{if isset($elasticsearch_results)}
	{include file="search_elastic.tpl"}
{else}
	{include file="search_classic.tpl"}
{/if}

{/block}
