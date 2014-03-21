{*<!-- ------------------------------------------------------------------
       range rendered several times for variable screen sizes
       ------------------------------------------------------------------ -->*}

{function name="button_class"}{strip}
btn btn-sm btn-default btn_range_{$range} btn_range{$suffix} btn_range_custom{$suffix} {if isset($smarty.get.range) && $smarty.get.range == $range}active{/if}
{/strip}{/function}

{function name="human_range"}{strip}
{capture assign=a}{$selrange->range_start_human|date_format:$format}{/capture}
{capture assign=b}{$selrange->range_end_human|date_format:$format}{/capture}
{if $a == $b}{$a}{else}{$a}-{$b}{/if}
{/strip}{/function}

{function name="prev_next"}

<table class="calendar_nav_hint" style="width:100%">
	<tr>
		<td style="text-align:left">
			<a 
				title="Previous {$smarty.get.range}" 
				class="btn btn-primaryx btn-xs" 
				role="button" 
				href="?{rewrite day=$selrange->prev->range_start_human until=$selrange->prev->range_end_human}{/rewrite}"
			><span class="glyphicon glyphicon-arrow-left"></span> {human_range selrange=$selrange->prev format=$format}</a>
		</td>
		<td></td>
		<td style="text-align:right">
			<a 
				title="Next {$smarty.get.range}" 
				class="btn btn-primaryx btn-xs" 
				role="button" 
				href="?{rewrite day=$selrange->next->range_start_human until=$selrange->next->range_end_human}{/rewrite}"
			>{human_range selrange=$selrange->next format=$format} <span class="glyphicon glyphicon-arrow-right"></span></a>
		</td>
	</tr>
</table>

{/function}

{function name=all_buttons}

<table border="0" style="width:100%">
<tr>
	<td style="width:10%">
		<a 
			class="{button_class range=day suffix=$suffix}" 
			style="width:100%"
			href="?{rewrite range=day erase='edit,until'}{/rewrite}" 
		>Day ({$range->day->range_start_human|date_format:"n/d"})</a>
	</td>
	<td style="width:20%">
		<a
			class="{button_class range=week suffix=$suffix}" 
			style="width:100%"
			href="?{rewrite range=week erase='edit,until'}{/rewrite}" 
		>Week ({$range->week->range_start_human|date_format:"n/d"} - {$range->week->range_end_human|date_format:"n/d"})</a>
	</td>
	<td style="width:60%">
		<a 
			class="{button_class range=month suffix=$suffix}" 
			style="width:100%"
			href="?{rewrite range=month erase='edit,until'}{/rewrite}" 
		>Month ({$range->month->range_start_human|date_format:"F"})</a>
	</td>
	<td style="">
{if $smarty.get.range == 'custom'}
		<a 
			title="Use the date dropdown on the right"
			class="{button_class range=custom suffix=$suffix}" 
			style="width:100%"
		>Custom</a>
{/if}
	</td>
</tr>
<tr>
	<td>{if $smarty.get.range == 'day'}{prev_next selrange=$range->day format="n/d"}{/if}</td>
	<td>{if $smarty.get.range == 'week'}{prev_next selrange=$range->week format="n/d"}{/if}</td>
	<td>{if $smarty.get.range == 'month'}{prev_next selrange=$range->month format="F Y"}{/if}</td>
	<td></td>
</tr>
</table>

{*<!--
<div class="btn-group btn-group-sm insights_range {$classes}">
	<span class="btn btn-inactive">Date range:</span>
	
	<button 
		class="{button_class range=day suffix=$suffix}" 
		onclick="window.location='?{rewrite range=day erase=until}{/rewrite}';" 
	>Day</button>

	<button 
		class="{button_class range=week suffix=$suffix}" 
		onclick="window.location='?{rewrite range=week}{/rewrite}';" 
	>Week</button>

	<button 
		class="{button_class range=month suffix=$suffix}"
		onclick="window.location='?{rewrite range=month}{/rewrite}';"
	>Month</button>

	<button 
		class="{button_class range=custom suffix=$suffix}" onclick="window.location='?{rewrite range=custom}{/rewrite}';"
	>Custom</button>
</div>
-->*}

{/function}

<div class="insights_range">
<table style="width:100%" border="0" class="">
	<tr>
		<td rowspan="2">
			{all_buttons classes="" suffix="_sm"}
		</td>
		<td colspan="3">
			<div style="border-bottom:1px solid rgb(230,230,230)">Custom Range</div>
		</td>
	</tr>
	<tr>
		<td style=""></td>
		<td style="width:60px">
			<a 
				title="Pick from calendar" 
				class="btn btn-primaryx btn-xs pick_date" 
				role="button" 
				data-date="2014-03-20" 
				data-date-format="yyyy-mm-dd"
			>
				<span class="glyphicon glyphicon-calendar"></span>&nbsp;From:<br/>
				<span class="display_date" id="id_range_from">{$range->active->range_start|date_format:"Y-m-d"}</span>
			</a>
		</td>
		<td style="width:60px">
			<a 
				title="Pick from calendar" 
				class="btn btn-primaryx btn-xs pick_date" 
				role="button" 
				data-date="2014-03-20" 
				data-date-format="yyyy-mm-dd"
			>
				<span class="glyphicon glyphicon-calendar"></span>&nbsp;Until:<br/>
				<span class="display_date" id="id_range_until">{$range->active->range_end|date_format:"Y-m-d"}</span>
			</a>
		</td>
		<td style="width:20px">
			<button 
				id="id_go_button" 
				class="go_button btn btn-xs btn-default" 
				url="?{rewrite erase='edit,day,until' range='custom'}{/rewrite}"
				style="height:40px;width:35px;"
			>Go</button>
		</td>
	</tr>
</table>
</div>

{*
{all_buttons classes="visible-xs visible-sm" suffix="_sm"}
{all_buttons classes="visible-lg visible-md" suffix=""}
*}

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

{if !isset($smarty.get.keywords)}

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

<div class="btn-group btn-group-sm insights_show_by_menu">
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
			href="?{rewrite all=1 erase='more,show'}{/rewrite}" 
			title="Show all entries for {$range->day->range_start_human|date_format:'M d, Y'} in list form"
		>
			All ({$entries|count} {if $entries|count == 1}entry{else}entries{/if})
		</a>
	</span>
</div>

{/if}
