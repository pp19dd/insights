
{*<!--

	checked=checked if $item.id is located somewhere in value

-->*}
<div class="form-group">
	<label class="col-sm-2 control-label">{$label}</label>
	<div class="col-sm-10">
{foreach from=$data item=item}
		<label class="checkbox-inline insights_checkbox_label">
			<input 
				name="{$name}" 
				type="checkbox"
{if !$can_edit}				disabled="disabled"{/if}
{if isset($value[$item.id])}				checked="checked"{/if}
				id="{$id}_{$item@index}" 
				value="{$item.id}"
				class="insights_checkbox"
			> {$item.name}
		</label>
{/foreach}

{if isset($append_html)}
{$append_html}
{/if}

	</div>
</div>
