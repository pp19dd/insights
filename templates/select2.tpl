
<div class="form-group">
	<label class="col-sm-2 control-label">{$label}</label>
	<div class="col-sm-10">
{if $optgroup}
		<select name="{$name}" class="parse_select2" data-placeholder="{$placeholder}" style="{$style}" id="{$id}">
{if $empty}
			<option></option>
{/if}
{foreach from=$data key=key_outer item=item_outer}
			<optgroup label="{$key_outer}">
{foreach from=$item_outer key=key_inner item=item_inner}
				<option {if isset($value[$key_inner])}selected="selected" {/if} value="{$key_inner}"> {$item_inner}</option>
{/foreach}
			</optgroup>
{/foreach}
		</select>
{else}

		<input 
			type="hidden" 
			name="{$name}" 
			class="parse_select2b" 
			data-placeholder="{$placeholder}" 
			insights_data="{$data}" 
			style="{$style}" 
			id="{$id}" 
			data-selected="{$value|array_keys|implode:','}"
		/>

{*<!--

data-selected is parsed in js

$("#e8_2_set2").click(function () {
	$("#e8_2").select2(
		"data", [{id: "CA", text: "California"},{id:"MA", text: "Massachusetts"}]
	);
});

	

		<select name="{$name}" class="parse_select2" data-placeholder="{$placeholder}" style="{$style}" id="{$id}">
{if $empty}
			<option></option>
{/if}
{foreach from=$data key=key item=item}
			<option value="{$key}">{$item}</option>
{/foreach}
		</select>
-->*}
{/if}
		
	</div>
</div>

{*<!--
<pre>{$value|print_r}</pre>
-->*}