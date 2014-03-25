
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

<style>
.row_count_0 { display: none }
</style>

<p><a href="#" onclick="$('.row_count_0').toggle(); return(false);">Toggle hidden rows.</a></p>

<div class="panel panel-default">
	<table class="table sortable">
		<thead>
			<tr>
{foreach from=$first key=field item=dummy}
{if !$hide || !in_array($field,$hide)}
				<th class="{if $field=='id'}left-most{/if}">{$field}</th>
{/if}
{/foreach}
{if $editable}
				<th></th>
{/if}
			</tr>
		</thead>
		<tbody>
{foreach from=$data item=row}
			<tr class="row_count_{$row.count}">
{foreach from=$row key=field item=cell}
{if !$hide || !in_array($field,$hide)}
				<td class="{if $field=='id'}left-most{/if}">{$cell}</td>
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
