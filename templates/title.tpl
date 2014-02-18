{strip}

{if $can.view}

	{if isset($smarty.get.edit)}

		{if $can.edit == true}

<title>VOA Insights - {$today} - Editing # {$entry.id} - {$entry.slug}</title>

		{else}

<title>VOA Insights - {$today} - Viewing # {$entry.id} - {$entry.slug}</title>

		{/if}

	{elseif isset($smarty.get.all)}

<title>VOA Insights - {$today} - ALL</title>

	{elseif isset($smarty.get.show)}

		{if isset($smarty.get.more)}

<title>VOA Insights - {$today} - Show {$smarty.get.show} - {$smarty.get.more}</title>

		{else}

<title>VOA Insights - {$today} - Show {$smarty.get.show}</title>

		{/if}

	{else}

<title>VOA Insights - {$today}</title>

	{/if}

{else}

<title>VOA Insights - Restricted Access</title>

{/if}

{/strip}
