
<div class="container">
	<div role="navigation" class="navbar navbar-default navbar-inverse voa_insights_top">
		<div class="navbar-header">
			<button data-target=".navbar-collapse" data-toggle="collapse" class="navbar-toggle" type="button">
				<span class="sr-only">Toggle navigation</span>
				<span class="icon-bar"></span>
				<span class="icon-bar"></span>
				<span class="icon-bar"></span>
			</button>
			<a href="{$base_url}" title="Home / Today" class="navbar-brand voa-insights-brand">Insights</a>
		</div>
		<div class="navbar-collapse collapse">
			<ul class="nav navbar-nav navbar-right">

{if $can.view}
<li>
<span class="btn btn-sm">
	<form method="get" action="{$base_url}?" class="btn btn-sm">

		<input type="hidden" name="day" id="id_search_form_date_start" value="{$range->active->range_start_human}" />
		<input type="hidden" name="until" id="id_search_form_date_end" value="{$range->active->range_end_human}" />
		<input type="hidden" name="range" id="id_search_form_date_range" value="{$smarty.get.range}" />

		<input 
			title="Click or hit ESC key to show" 
			class="btn btn-xs" type="button" 
			value="Add insight..."
			role="button" id="pick_add_insight"
			style="margin-right:20px"
		/>

		<span style="color:silver">Keywords:&nbsp;</span>
		<input type="text" value="{if isset($smarty.get.keywords)}{$smarty.get.keywords}{/if}" name="keywords" autocomplete="off" />
		<input style="margin-right:10px" class="btn btn-xs" type="submit" name="search" value="Search" />


	</form>
</span>
</li>
{/if}

			</ul>
		</div><!--/.nav-collapse -->
	</div>
</div>
