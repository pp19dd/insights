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
{$entry = $entries[$entry_id]}

<tr class="insights_entry insights_entry_id_{$entry.id} insights_entry_starred_{$entry.is_starred|lower}">
	<td class="entry_field entry_slug">{$entry.slug}</td>
	<td class="entry_field entry_description">{$entry.description}</td>
	<td class="entry_field entry_deadline">{$entry.deadline} {$entry.deadline_time}</td>
	<td class="entry_field entry_services">{map set=$entry.map.services}</td>
	<td class="entry_field entry_mediums">{map set=$entry.map.mediums}</td>
	<td class="entry_field entry_beats">{map set=$entry.map.beats}</td>
	<td class="entry_field entry_regions">{map set=$entry.map.regions}</td>
	<td class="entry_field entry_reporters">{map set=$entry.map.reporters}</td>
	<td class="entry_field entry_editors">{map set=$entry.map.editors}</td>
	<td class="entry_field entry_edit">
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
	<table class="table sortable">
		<thead>
			<tr>
				<th>Slug</th>
				<th>Description</th>
				<th>Deadline</th>
				<th>Origin</th>
				<th>Medium</th>
				<th>Beat</th>
				<th>Region</th>
				<th>Reporter</th>
				<th>Editor</th>
				<th class="insights_grid_list_action"></th>
			</tr>
		</thead>
		<tbody>
{foreach from=$ids item=id}
{show_entry entry_id=$id}
{/foreach}
		</tbody>
	</table>
</div>

