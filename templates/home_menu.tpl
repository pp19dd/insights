
{*<!-- ------------------------------------------------------------------
       menu buttons for different map filters
       ------------------------------------------------------------------ -->*}

{function name=insights_show}
<button type="button" class="btn btn-default {if $smarty.get.show==$parm}{*btn-primary*}active{/if}" onclick="window.location='?{rewrite show=$parm erase='edit,more,all'}{/rewrite}';">{$label}{if $count} <span class="disabled_badge insights_entry_count">{$count}</span>{/if}</button>
{/function}

<div class="btn-group insights_show_by_menu">
	<span class="btn btn-inactive">
		<div class="insights_today_date">{$today|date_format:'M d, Y'}</div>
		{*<!--<div class="insights_number_entries">{$entries|count} {if $entries|count == 1}entry{else}entries{/if}</div>-->*}
	</span>
	<span class="btn btn-inactive">Show by:</span>
	{insights_show parm="regions" label="Region" count=count($all_maps['regions'])}
	{insights_show parm="beats" label="Beat" count=count($all_maps['beats'])}
	<span class="btn btn-inactive">&nbsp;</span>
	{insights_show parm="divisions" label="Division" count=count($all_maps['divisions'])}
	{insights_show parm="services" label="Service" count=count($all_maps['services'])}
	<span class="btn btn-inactive">&nbsp;</span>
	{insights_show parm="mediums" label="Medium" count=count($all_maps['mediums'])}
	<span class="btn btn-inactive">&nbsp;</span>
	{insights_show parm="reporters" label="Reporter" count=count($all_maps['reporters'])}
	{insights_show parm="editors" label="Editor" count=count($all_maps['editors'])}
	<span class="btn btn-inactive"><a href="?all&day={$today}" title="Show all entries for {$today|date_format:'M d, Y'} in list form">All ({$entries|count} {if $entries|count == 1}entry{else}entries{/if})</a></span>
</div>
