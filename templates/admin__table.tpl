
{capture}
{$first = $data|array_slice:0:1|array_shift}
{/capture}

{if !isset($list)}{$list = false}{/if}

{if $add}
<div class="btn-group">
	<button type="button" class="btn btn-default" onclick="window.location='?edit=-1'">Add new...</button>
</div>
<br/>
<br/>
{/if}

<p style="margin-left:40px">
	Filter: <input type="text" autocomplete="off" id="filter_name" value="" />
	<label><input id="show_empty_rows" type="checkbox" onclick="toggle_hidden(this);" /> Show empty rows.</label>
</p> 

<div class="panel panel-default">
	<table class="table sortable" id="sortable_admin_table">
		<thead>
			<tr>
{foreach from=$first key=field item=dummy}
{if !$hide || !in_array($field,$hide)}
				<th class="{if $field=='id'}left-most {/if} th_{$field}">{$field}</th>
{/if}
{/foreach}
{if $editable}
				<th></th>
{/if}
{if $list}
				<th></th>
{/if}
			</tr>
		</thead>
		<tbody>
{foreach from=$data item=row}
			<tr class="admin_row row_count_{$row.count}">
{foreach from=$row key=field item=cell}
{if !$hide || !in_array($field,$hide)}
				<td class="{if $field=='id'}left-most {/if}td_{$field}">{$cell}</td>
{/if}
{/foreach}
{if $editable}
				<td class="right-most">
					<div class="btn-group">
						<button type="button" class="btn btn-default" record-id="{$row.id}" onclick="window.location='?edit={$row.id}'">Edit</button>
					</div>
					<div class="btn-group">
						<button type="button" class="btn btn-default deletion_button" record-id="{$row.id}">Delete</button>
					</div>
				</td>
{/if}
{if $list}
				<td class="right-most">
					<a href="{$base_url}?all&term_type={$list}&term_id={$row.id}" type="button" class="btn btn-default btn-sm" record-id="{$row.id}">List Records</a>
				</td>
{/if}
			</tr>
{/foreach}
		</tbody>
	</table>

</div>

