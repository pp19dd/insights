
{*<!--

	checked=checked if $item.id is located somewhere in value

-->*}
<div class="form-group">
	<label class="col-sm-2 control-label">{$label}</label>
	<div class="col-sm-10">
{foreach from=$data item=item}
		<label class="checkbox-inline">
			<input 
				name="{$name}" 
				type="checkbox" 
				{if isset($value[$item.id])}checked="checked" {/if}
				id="{$id}_{$item@index}" 
				value="{$item.id}"
			> {$item.name}
		</label>
{/foreach}
	</div>
</div>

{*<!--
data=
<pre>{$data|print_r}</pre>

{if $value}
value=
<pre>{$value|print_r}</pre>
{/if}
-->*}