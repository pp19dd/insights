
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

{if $can.view}
<li>
<span class="btn btn-sm">
	<form method="get" action="{$base_url}?" class="btn btn-sm">
		<span style="color:silver">Keywords:&nbsp;</span>
		<input type="text" value="{if isset($smarty.get.keywords)}{$smarty.get.keywords}{/if}" name="keywords" autocomplete="off" />
		<input style="margin-right:10px" class="btn btn-xs" type="submit" name="search" value="Search" />

		<input 
			title="Click or hit ESC key to show" 
			class="btn btn-xs" type="button" 
			value="Add insight..."
			role="button" id="pick_add_insight"
		/>

	</form>
</span>
</li>
{/if}

			</ul>
		</div><!--/.nav-collapse -->
	</div>
</div>
