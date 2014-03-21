{extends file='template.tpl'}

{block name='footer'}
{/block}

{block name='content'}

{include file="home_menu.tpl"}

{if isset($error) && $error}
<div class="alert alert-danger alert-dismissable">

	<button type="button" class="close" data-dismiss="alert" aria-hidden="true">&times;</button>
	
	<p>{$error}</p>

</div>
{/if}


{if isset($smarty.get.more)}

<div class="row">

<h1>Showing {$smarty.get.more}</h1>
<p><a href="?{rewrite erase=more}{/rewrite}">Back: View all {$smarty.get.show}</a></p>

<hr/>

{if isset($grouped_entries)}
	<div class="more_view">
	{foreach from=$grouped_entries key=entry_group item=data}
		{if $entry_group == $smarty.get.more}
			{include file="table_entries.tpl" ids=$data.all entries=$entries}
		{/if}
	{/foreach}
	</div>
{/if}

</div><!-- .row -->

{else}

<div class="row">
	{if isset($grouped_entries)}
		{foreach from=$grouped_entries key=entry_group item=data}
	<div class="col-md-4">
		<h3>{$entry_group|default:"(Unknown)"}</h3>

			{if $data.starred|count > 0}
			<ul>
				{foreach from=$data.starred item=entry_id}
				{$entry = $entries[$entry_id]}
				<li class="insights_entry insights_entry_id_{$entry.id} insights_entry_starred_{$entry.is_starred|lower}">
					<div class="insights_slug">
						<a href="?{rewrite edit=$entry.id}{/rewrite}">{$entry.slug|default:"(Untitled)"}</a>
					</div>
					<div class="insights_description">{$entry.description|default:"(Blank)"}</div>
				</li>
				{/foreach}
			</ul>
			{/if}
			<p>
				<a 
					class="btn btn-default" 
					href="?{rewrite more=$entry_group erase=deleted}{/rewrite}" 
					role="button"
				>View all ({$data.all|count}) &raquo;</a>
			</p>
	</div>
		{/foreach}
	{/if}
</div>

{/if}


{if isset($smarty.get.all)}
<h1>Showing all entries for {$range->day->range_start_human|date_format:"M d, Y"}</h1>

{include file="table_entries.tpl" ids=$entries|array_keys entries=$entries}

{/if}

<hr/>

{/block}
