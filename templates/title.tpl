{strip}

{if $can.view}

	{if isset($smarty.get.edit)}

		{if $can.edit == true}

<title>VOA Insights - {$range->day->range_start_human} - Editing # {$entry.id} - {$entry.slug}</title>

		{else}

<title>VOA Insights - {$range->day->range_start_human} - Viewing # {$entry.id} - {$entry.slug}</title>

		{/if}

	{elseif isset($smarty.get.all)}

<title>VOA Insights - {$range->day->range_start_human} - ALL</title>

	{elseif isset($smarty.get.show)}

		{if isset($smarty.get.more)}

<title>VOA Insights - {$range->day->range_start_human} - Show {$smarty.get.show} - {$smarty.get.more}</title>

		{else}

<title>VOA Insights - {$range->day->range_start_human} - Show {$smarty.get.show}</title>

		{/if}

	{else}

<title>VOA Insights - {$range->day->range_start_human}</title>

	{/if}

{else}

<title>VOA Insights - Restricted Access</title>

{/if}

{/strip}