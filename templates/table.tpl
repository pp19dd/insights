
{capture}
{$first = $data|array_slice:0:1|array_shift}
{/capture}

{if $add}
<div class="btn-group">
	<button type="button" class="btn btn-default" onclick="window.location='?edit=-1'">Add new...</button>
</div>
<br/>
<br/>
{/if}

<div class="panel panel-default">
	<table class="table">
		<thead>
{foreach from=$first key=field item=dummy}
{if !$hide || !in_array($field,$hide)}
			<th class="{if $field=='id'}left-most{/if}">{$field}</th>
{/if}
{/foreach}
{if $editable}
			<th></th>
{/if}
		</thead>
		<tbody>
{foreach from=$data item=row}
			<tr>
{foreach from=$row key=field item=cell}
{if !$hide || !in_array($field,$hide)}
				<td class="{if $field=='id'}left-most{/if}">{$cell}</td>
{/if}
{/foreach}
{if $editable}
				<td class="right-most">
{*<!--
					<div class="btn-group">
						<span type="button" class="  glyphicon glyphicon-star"></span>
						<span class=""></span>
					</div>
-->*}
					<div class="btn-group">
						<button type="button" class="btn btn-default" record-id="{$row.id}" onclick="window.location='?edit={$row.id}'">Edit</button>
					</div>
					<div class="btn-group">
						<button type="button" class="btn btn-default deletion_button" record-id="{$row.id}">Delete</button>
					</div>
				</td>
{/if}
			</tr>
		</tbody>
{/foreach}
	</table>

</div>
