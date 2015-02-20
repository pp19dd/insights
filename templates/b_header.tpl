
<div class="container insights_navigation">
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

{if $can.view && !$is_admin}
<li>
	<span class="btn btn-sm">
		<a href="{$base_url}?range=day&day=watchlist&all=1">Watch<br/>List</a>
		<span class="disabled_badge insights_entry_count insights_watchlist_count"></span>
	</span>
</li>
<li>
	<span class="btn btn-sm">
		<a href="{$base_url}?range=day&day=HFR&all=1">Hold For<br/>Release</a>
		<span class="disabled_badge insights_entry_count">{$activity.hfr}</span>
	</span>
</li>
<li>
	<span class="btn btn-sm" id="pick_add_insight">
		<a>+ Create a <br/>New Insight</a>
	</span>
	{*<!--
	<input
		title="Click or hit ESC key to show"
		class="btn btn-xs" type="button"
		value="Add insight..."
		role="button" id="pick_add_insight"
		style="margin-right:20px"
	/>
	-->*}
</li>
{/if}

			</ul>
		</div><!--/.nav-collapse -->
	</div>
</div>
