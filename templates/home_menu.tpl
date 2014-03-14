{*<!-- ------------------------------------------------------------------
       range rendered several times for variable screen sizes
       ------------------------------------------------------------------ -->*}

{function name=all_buttons}

<div class="btn-group insights_range {$classes}">
	<span class="btn btn-inactive">Date range:</span>
	<button class="btn btn-default btn_range{$suffix} btn_range_day{$suffix} {if isset($smarty.get.range) && $smarty.get.range == 'day'}active{/if}" onclick="window.location='?{rewrite range=day erase=until}{/rewrite}';" type="button">Day</button>
	<button class="btn btn-default btn_range{$suffix} btn_range_week{$suffix} {if isset($smarty.get.range) && $smarty.get.range == 'week'}active{/if}" onclick="window.location='?{rewrite range=week}{/rewrite}';" type="button">Week</button>
	<button class="btn btn-default btn_range{$suffix} btn_range_month{$suffix} {if isset($smarty.get.range) && $smarty.get.range == 'month'}active{/if}" onclick="window.location='?{rewrite range=month}{/rewrite}';" type="button">Month</button>
	<button class="btn btn-default btn_range{$suffix} btn_range_custom{$suffix}" onclick="window.location='?{rewrite range=custom}{/rewrite}';" type="button">Custom</button>
</div>

{/function}

{all_buttons classes="visible-xs visible-sm" suffix="_sm"}
{all_buttons classes="visible-lg visible-md" suffix=""}


{*<!--
{if $can.view == true}
<li class=""><a title="Previous day" class="btn btn-primaryx btn-md" role="button" id="pick_date_prev"><span class="glyphicon glyphicon-arrow-left"></span></a></li>
<li class=""><a title="Pick from calendar" class="btn btn-primaryx btn-md" role="button" id="pick_date" data-date="{$range->day->range_start_human|date_format:'Y-m-d'}" data-date-format="yyyy-mm-dd"><span class="glyphicon glyphicon-calendar"></span>&nbsp;{$range->day->range_start_human|date_format:'M d, Y'}</a></li>
<li class=""><a title="Next day" class="btn btn-primaryx btn-md" role="button" id="pick_date_next"><span class="glyphicon glyphicon-arrow-right"></span></a></li>
{/if}
-->*}

<div class="clearfix after_range"></div>

{*<!--
<div class="btn-group insights_range_definition">
	<span class="btn btn-inactive">Showing:</span>

	{$range->day->range_start_human}
</div>

<div class="clearfix after_range"></div>
-->*}


{*<!-- ------------------------------------------------------------------
       menu buttons for different map filters
       ------------------------------------------------------------------ -->*}

{function name=insights_show}
<button 
	type="button" 
	class="btn btn-default {if isset($smarty.get.show) and $smarty.get.show==$parm}{*btn-primary*}active{/if}" 
	onclick="window.location='?{rewrite show=$parm erase='edit,more,all,logout,login,deleted'}{/rewrite}';"
>{$label}{if $count} <span class="disabled_badge insights_entry_count">{$count}</span>{/if}</button>
{/function}

<div class="btn-group insights_show_by_menu">
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
	<span class="btn btn-inactive">
		<a 
			href="?all&day={$range->day->range_start_human}" 
			title="Show all entries for {$range->day->range_start_human|date_format:'M d, Y'} in list form"
		>
			All ({$entries|count} {if $entries|count == 1}entry{else}entries{/if})
		</a>
	</span>
</div>
