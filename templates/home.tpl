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

{*<!-- ------------------------------------------------------------------
       traverse a related-items map and display as single lines
       ------------------------------------------------------------------ -->*}
{function name=map}
	{if $set}
		{if $set|count > 0}
			{foreach from=$set item=item}
			{$item.resolved.name}{if not $item@last},{/if}
			{/foreach}
		{else}
			{foreach from=$set item=item}
				{$item.resolved.name}
			{/foreach}
		{/if}
	{/if}
{/function}

{*<!-- ------------------------------------------------------------------
       display all table header
       ------------------------------------------------------------------ -->*}
{function name=table_header}
<thead>
	<tr>
		<th>Slug</th>
		<th>Description</th>
{*<!--<th>Deadline</th>-->*}
		<th>Origin</th>
		<th>Medium</th>
		<th>Beat</th>
		<th>Region</th>
		<th>Reporter</th>
		<th>Editor</th>
		<th class="insights_grid_list_action"></th>
	</tr>
</thead>
{/function}

{*<!-- ------------------------------------------------------------------
       show one entry line
       ------------------------------------------------------------------ -->*}
{function name=show_entry}
{$entry = $entries[$entry_id]}

{if isset($table)}
<tr class="insights_entry insights_entry_id_{$entry.id} insights_entry_starred_{$entry.is_starred|lower}">
	<td>{$entry.slug}</td>
	<td>{$entry.description}</td>
	{*<!--<td>{$entry.deadline}</td>-->*}
	<td>{map set=$entry.map.services}</td>
	<td>{map set=$entry.map.mediums}</td>
	<td>{map set=$entry.map.beats}</td>
	<td>{map set=$entry.map.regions}</td>
	<td>{map set=$entry.map.reporters}</td>
	<td>{map set=$entry.map.editors}</td>
	<td>
		<div class="btn-group">
			<button 
				onclick="window.location='?{rewrite edit=$entry.id}{/rewrite}'" 
				class="btn btn-default" 
				type="button"
			>
			<span class="glyphicon {if $entry.is_starred=='Yes'}glyphicon-star insights_star_note_starred{else}glyphicon-star-empty{/if}"></span>
			{if $can.edit}Edit{else}View{/if}
			</button>
		</div>
	</td>
</tr>
{else}
<li class="insights_entry insights_entry_id_{$entry.id} insights_entry_starred_{$entry.is_starred|lower}">
	<div class="insights_slug">
		<a href="?{rewrite edit=$entry.id}{/rewrite}">{$entry.slug|default:"(Untitled)"}</a>
	</div>
	<div class="insights_description">{$entry.description|default:"(Blank)"}</div>
</li>

{/if}

{/function}
{*<!-- ------------------------------------------------------------------ -->*}

{if isset($smarty.get.more)}

<div class="row">


<h1>Showing {$smarty.get.more}</h1>
<p><a href="?{rewrite erase=more}{/rewrite}">Back: View all {$smarty.get.show}</a></p>

<hr/>

{if isset($grouped_entries)}
	<div class="more_view">
{foreach from=$grouped_entries key=entry_group item=data}
{if $entry_group == $smarty.get.more}
<div class="panel panel-default">
	<table class="table sortable">
{table_header}
		<tbody>
{foreach from=$data.all item=entry_id}
			{show_entry id=$entry_id table=true}
{/foreach}
		</tbody>
	</table>
</div>	
{/if}
{/foreach}
	</div>
{/if}

</div>

{else}

<div class="row">
{if isset($grouped_entries)}
{foreach from=$grouped_entries key=entry_group item=data}
	<div class="col-md-4">
		<h3>{$entry_group|default:"(Unknown)"}</h3>

{if $data.starred|count > 0}
<ul>
{foreach from=$data.starred item=entry_id}
	{show_entry id=$entry_id}
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
{/if}
</div>

{if isset($smarty.get.all)}
<h1>Showing all entries for {$today|date_format:"M d, Y"}</h1>

<div class="panel panel-default">
	<table class="table sortable">
		{table_header}
			<tbody>
{foreach from=$entries key=entry_id item=dummy}
				{show_entry id=$entry_id table=true}
{/foreach}
			</tbody>
	</table>
</div>

{/if}

<hr/>

{/block}
