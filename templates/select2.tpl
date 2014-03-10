{*<!--
	three modes of operation
		1. select element with inline data
		2. select element with inline data and optgroups
		3. hidden input element with dynamic data

	required parameter: $mode
		mode = 1
		mode = 2
		mode = 3

	optional parameter: $skip_container = true
-->*}

{function select_mode_1}

<select 
	id="{$id}"
	name="{$name}" 
	class="parse_select2" 
	style="{$style}" 
	separator=";"
{if isset($can_clear)}
	data-can-clear="true"
{/if}
	{if !$can.edit}disabled="disabled"{/if}
	{if isset($placeholder)}data-placeholder="{$placeholder}"{/if}

>
{if isset($empty)}<option></option>{/if}
{foreach from=$data key=key_inner item=item_inner}
	<option {if isset($value[$key_inner])}selected="selected" {/if} value="{$key_inner}"> {$item_inner}</option>
{/foreach}
</select>

{/function}

{function select_mode_2}

<select 
	id="{$id}"
	name="{$name}" 
	class="parse_select2" 
	style="{$style}" 
	separator=";"
{if isset($can_clear)}
	data-can-clear="true"
{/if}
	{if !$can.edit}disabled="disabled"{/if}
	{if isset($placeholder)}data-placeholder="{$placeholder}"{/if}

>
{if isset($empty)}<option></option>{/if}
{foreach from=$data key=key_outer item=item_outer}
	<optgroup label="{$key_outer}">
{foreach from=$item_outer key=key_inner item=item_inner}
		<option {if isset($value[$key_inner])}selected="selected" {/if} value="{$key_inner}"> {$item_inner}</option>
{/foreach}
	</optgroup>
{/foreach}
</select>


{/function}

{function select_mode_3}
<input 
	id="{$id}" 
	type="hidden" 
	name="{$name}" 
	class="parse_select2b"
	separator=";" 
	style="{$style}" 
{if isset($can_clear)}
	data-can-clear="true"
{/if}
	{if !$can.edit}readonly="readonly"{/if}
	{if isset($placeholder)}data-placeholder="{$placeholder}"{/if}
	insights_data="{$data}" 
	data-selected="{if isset($value)}{$value|array_keys|implode:','}{/if}"

/>
{/function}


{if !isset($skip_container)}
<div class="form-group">
	<label class="col-sm-2 control-label">{$label}</label>
	<div class="col-sm-10">
{/if}

{if $mode === 1}
	{select_mode_1}
{elseif $mode === 2}
	{select_mode_2}
{else}
	{select_mode_3}
{/if}

{if !isset($skip_container)}
	</div>
</div>
{/if}		
