
{capture}
{$first = $data|array_slice:0:1|array_shift}
{/capture}

{if !isset($list)}{$list = false}{else}<script>var list = "{$list}";</script>{/if}
{if !isset($rename)}{$rename = false}{/if}
{if !isset($merge)}{$merge = false}{/if}

{if $add}
<div class="btn-group">
	<button type="button" class="btn btn-default" onclick="window.location='?edit=-1'">Add new...</button>
</div>
<br/>
<br/>
{/if}

<p style="margin-left:40px">
	Filter: <input type="text" autocomplete="off" id="filter_name" value="" style="width:300px" />
	<label><input id="filter_empty" type="checkbox" /> Show empty rows.</label>
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
{if $merge}<th style="width:50px">Merge</th>{/if}
{if $editable}<th></th>{/if}
{if $rename}<th></th>{/if}
{if $list}<th></th>{/if}
			</tr>
		</thead>
		<tbody>
{foreach from=$data item=row}
			<tr class="admin_row row_count_{$row.count} row_id_{$row.id}">
{foreach from=$row key=field item=cell}
{if !$hide || !in_array($field,$hide)}
				<td class="{if $field=='id'}left-most {/if}td_{$field}">{$cell}</td>
{/if}
{/foreach}
{if $merge}
				<td style="width:50px; text-align:center">
					<input type="checkbox" class="merge" record-id="{$row.id} " title="Select several items to merge" />
				</td>
{/if}
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
{if $rename}
				<td class="right-most" style="width:125px">
					<a href="#" onclick="rename_term({$row.id}, this, '{$list}'); return(false);" type="button" class="btn btn-default btn-sm" record-id="{$row.id}">Rename</a>
				</td>
{/if}
{if $list}
				<td class="right-most" style="width:125px">
					<a href="{$base_url}?all&term_type={$list}&term_id={$row.id}" type="button" class="btn btn-default btn-sm" record-id="{$row.id}">List Records</a>
				</td>
{/if}
			</tr>
{/foreach}
		</tbody>
	</table>


</div>


{if $merge}
<p>Selected items to merge: <span id="merge_count">0</span></p>
<button onclick="merge_items()" class="btn btn-default">Merge Checked Items...</button>
<button onclick="clear_merge_terms()" class="btn btn-default">Clear Selection</button>
{/if}
