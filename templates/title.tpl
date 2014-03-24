{strip}

{function name="range_title"}{strip}
{capture assign=a}{$range->active->range_start_human}{/capture}
{capture assign=b}{$range->active->range_end_human}{/capture}
{if $a == $b}{$a}{else}{$a} to {$b} ({$smarty.get.range}){/if}
{/strip}{/function}

{if $can.view}

	{if isset($smarty.get.keywords)}

<title>VOA Insights - {range_title} - Search {$smarty.get.keywords}</title>

	{elseif isset($smarty.get.edit)}

		{if $can.edit == true}

<title>VOA Insights - {range_title} - Editing # {$entry.id} - {$entry.slug}</title>

		{else}

<title>VOA Insights - {range_title} - Viewing # {$entry.id} - {$entry.slug}</title>

		{/if}

	{elseif isset($smarty.get.all)}

<title>VOA Insights - {range_title} - ALL</title>

	{elseif isset($smarty.get.show)}

		{if isset($smarty.get.more)}

<title>VOA Insights - {range_title} - Show {$smarty.get.show} - {$smarty.get.more}</title>

		{else}

<title>VOA Insights - {range_title} - Show {$smarty.get.show}</title>

		{/if}

	{else}

<title>VOA Insights - {range_title}</title>

	{/if}

{else}

<title>VOA Insights - Restricted Access</title>

{/if}

{/strip}