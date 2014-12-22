{*<!-- ------------------------------------------------------------------
       traverse a related-items map and display as single lines
       ------------------------------------------------------------------ -->*}
{function name=map}{strip}
	{if $set}
		{if $set|count > 0}
			{foreach from=$set item=item}
				{if isset($item.resolved) && isset($item.resolved.name)}
					{$item.resolved.name}{if not $item@last}, {/if}
				{/if}
			{/foreach}
		{else}
			{foreach from=$set item=item}
				{if isset($item.resolved) && isset($item.resolved.name)}
					{$item.resolved.name}
				{/if}
			{/foreach}
		{/if}
	{/if}
{/strip}{/function}

{*<!-- ------------------------------------------------------------------
       show one entry line
       ------------------------------------------------------------------ -->*}
{function name=show_entry}

<tr class="insights_entry insights_entry_id_{$entry.id} insights_entry_starred_{$entry.is_starred|lower} {cycle values='even,odd'}">
	<td class="entry_field column_slug">{$entry.slug}</td>
	<td class="entry_field column_description">{$entry.description}</td>
	<td class="entry_field column_deadline">{if is_null($entry.deadline)}Hold for Release{else}{$entry.deadline} {$entry.deadline_time}{/if}</td>
	<td class="entry_field column_origin">{map set=$entry.map.services}</td>
	<td class="entry_field column_medium">{map set=$entry.map.mediums}</td>
	<td class="entry_field column_beat">{map set=$entry.map.beats}</td>
	<td class="entry_field column_region">{map set=$entry.map.regions}</td>
	<td class="entry_field column_reporter">{map set=$entry.map.reporters}</td>
	<td class="entry_field column_editor">{map set=$entry.map.editors}</td>
	<td class="entry_field column_action">
		<div class="btn-group">
			<a
{if isset($custom_edit_link)}
				href="{$base_url}?edit={$entry.id}"
{else}
				href="?{rewrite edit=$entry.id}{/rewrite}"
{/if}
				class="btn btn-default btn-sm"
				type="button"
			>
			<span class="glyphicon {if $entry.is_starred=='Yes'}glyphicon-star insights_star_note_starred{else}glyphicon-star-empty{/if}"></span>
			{if $can.edit}Edit{else}View{/if}
			</a>
		</div>
	</td>
</tr>

{/function}
{*<!-- ------------------------------------------------------------------ -->*}

<div class="row">

<div class="panel panel-default">
	<table class="table sortable" id="table_filterable">
		<thead>
			<tr>
				<th class="column_slug">Slug</th>
				<th class="column_description">Description</th>
				<th class="column_deadline">Deadline</th>
				<th class="column_origin">Origin</th>
				<th class="column_medium">Medium</th>
				<th class="column_beat">Beat</th>
				<th class="column_region">Region</th>
				<th class="column_reporter">Reporter</th>
				<th class="column_editor">Editor</th>
				<th class="column_action insights_grid_list_action" data-defaultsort='disabled'></th>
			</tr>
		</thead>
		<tbody>

{*<!-- ------------------------------------------------------------------
       show entry rows here
       variant 1: showing empty rows only
       variant 2: showing all
       ------------------------------------------------------------------ -->*}

{foreach from=$ids item=id}{$entry = $entries[$id]}

{if isset($smarty.get.all) && $smarty.get.all == "empty"}
	{if $entry.map_count === 0}
		{show_entry entry=$entry}
	{/if}
{else}
	{show_entry entry=$entry}
{/if}

{/foreach}
		</tbody>
	</table>
</div>
