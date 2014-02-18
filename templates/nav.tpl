
<div class="container">
	<div role="navigation" class="navbar navbar-default navbar-inverse voa_insights_top">
		<div class="navbar-header">
			<button data-target=".navbar-collapse" data-toggle="collapse" class="navbar-toggle" type="button">
				<span class="sr-only">Toggle navigation</span>
				<span class="icon-bar"></span>
				<span class="icon-bar"></span>
				<span class="icon-bar"></span>
			</button>
			<a href="{$base_url}" class="navbar-brand voa-insights-brand" href="">Insights</a>
		</div>
		<div class="navbar-collapse collapse">
			<ul class="nav navbar-nav navbar-right">
				<li><a title="Click or hit ESC key to show" class="btn btn-sm " role="button" id="pick_add_insight">Add insight...</a></li>
{if $can.view == true}
				<li class="{*active*}"><a title="Previous day" class="btn btn-primaryx btn-md" role="button" id="pick_date_prev"><span class="glyphicon glyphicon-arrow-left"></span></a></li>
				<li class=""><a title="Pick from calendar" class="btn btn-primaryx btn-md" role="button" id="pick_date" data-date="{$today|date_format:'Y-m-d'}" data-date-format="yyyy-mm-dd"><span class="glyphicon glyphicon-calendar"></span>&nbsp;{$today|date_format:'M d, Y'}</a></li>
				<li class=""><a title="Next day" class="btn btn-primaryx btn-md" role="button" id="pick_date_next"><span class="glyphicon glyphicon-arrow-right"></span></a></li>
{/if}
			</ul>
		</div><!--/.nav-collapse -->
	</div>
</div>
