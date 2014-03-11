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
       show one entry line
       ------------------------------------------------------------------ -->*}
{function name=show_entry}
{$entry = $entries[$entry_id]}

<tr class="insights_entry insights_entry_id_{$entry.id} insights_entry_starred_{$entry.is_starred|lower}">
	<td>{$entry.slug}</td>
	<td>{$entry.description}</td>
	<td>{$entry.deadline} {$entry.deadline_time}</td>
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

{/function}
{*<!-- ------------------------------------------------------------------ -->*}

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

