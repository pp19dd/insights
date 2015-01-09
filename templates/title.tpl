{function name="range_title"}{strip}
{capture assign=a}{$range->active->range_start_human}{/capture}
{capture assign=b}{$range->active->range_end_human}{/capture}
{if $a == $b}{$a}{else}{$a} to {$b} ({$smarty.get.range}){/if}
{/strip}{/function}
{strip}

{function name=title_restricted}<title>VOA Insights - Restricted Access</title>{/function}
{function name=title_search}<title>VOA Insights - {range_title} - Search {$smarty.get.keywords}</title>{/function}
{function name=title_editing}<title>VOA Insights - {range_title} - Editing # {$entry.id} - {$entry.slug}</title>{/function}
{function name=title_viewing}<title>VOA Insights - {range_title} - Viewing # {$entry.id} - {$entry.slug}</title>{/function}
{function name=title_all}<title>VOA Insights - {range_title} - ALL</title>{/function}
{function name=title_show_more}<title>VOA Insights - {range_title} - Show {$smarty.get.show} - {$smarty.get.more}</title>{/function}
{function name=title_show}<title>VOA Insights - {range_title} - Show {$smarty.get.show}</title>{/function}
{function name=title_range}<title>VOA Insights - {range_title}</title>{/function}
{function name=title_watchlist}<title>VOA Insights - Watch List</title>{/function}

{if $is_admin}
	<title>Admin</title>
{else}
	{if $can.view}
		{if isset($smarty.get.keywords)}
			{title_search}
		{elseif isset($smarty.get.edit)}
			{if $can.edit == true}
				{title_editing}
			{else}
				{title_viewing}
			{/if}
		{elseif isset($smarty.get.day) && $smarty.get.day=="watchlist"}
			{title_watchlist}
		{elseif isset($smarty.get.all)}
			{title_all}
		{elseif isset($smarty.get.show)}
			{if isset($smarty.get.more)}
				{title_show_more}
			{else}
				{title_show}
			{/if}
		{else}
			{title_range}
		{/if}
	{else}
		{title_restricted}
	{/if}
{/if}

{/strip}
