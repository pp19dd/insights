{extends file='template.tpl'}

{block name='footer'}
{/block}

{block name='content'}

{include file="home_menu.tpl"}

<div class="row">

<hr/>

<div class="container" id="entry_add_entry">

	<form role="form" class="form-horizontal" method="post" action="?{rewrite erase=edit}{/rewrite}">
		<input type="hidden" name="form_type" value="update_insight" />
		<input type="hidden" name="entry_id" value="{$entry.id}" />
		<input type="hidden" name="return_to" value="{rewrite erase=edit}{/rewrite}" />
		
		<div class="form-group">
			<label for="input_slug" class="col-sm-2 control-label">Slug</label>
			<div class="col-sm-10">
				<input 
					{if !$can.edit}readonly="readonly"{/if} 
					name="slug" type="text" 
					autocomplete="off" 
					class="form-control" 
					id="entry_input_slug" 
					placeholder="Insight slug" 
					value="{$entry.slug}" />
			</div>
		</div>
		<div class="form-group">
			<label for="input_slug" class="col-sm-2 control-label">Description</label>
			<div class="col-sm-10">
				<textarea 
					{if !$can.edit}readonly="readonly"{/if} 
					name="description" 
					class="form-control" 
					id="entry_input_description" 
					placeholder="Longer description of the story"
				>{$entry.description}</textarea>
			</div>
		</div>
		
{include
	file="checkbox.tpl"
	label="Mediums"
	name="mediums[]"
	id="entry_id_medium_"
	data=$mediums
	value=$entry.map.mediums
	can_edit=$can.edit
}

		<div class="form-group">
			<label for="input_slug" class="col-sm-2 control-label">Deadline</label>
			<div class="col-sm-10">
				<input 
					name="deadline" 
					{if !$can.edit}readonly="readonly"{/if} 
					type="text" 
					autocomplete="off" 
					class="form-control " 
					style="width:20%" 
					id="entry_deadline" 
					value="{$entry.deadline|date_format:'m/d/Y'}"
				/>
			</div>
		</div>
	
{include 
	file="select2.tpl" 
	label="Origin (Div/Svc)" 
	name="origin" 
	id="entry_id_division_service" 
	placeholder="Select division / language service" 
	style="width:50%" 
	empty=true 
	optgroup=true 
	data=$divisions_and_services
	value=$entry.map.services
	can_edit=$can.edit
}

{include 
	file="select2.tpl" 
	label="Reporter" 
	name="reporters" 
	id="entry_id_reporter" 
	placeholder="Reporter" 
	style="width:50%" 
	empty=true 
	optgroup=false 
	data="reporters"
	value=$entry.map.reporters
	can_edit=$can.edit
}

{include 
	file="select2.tpl" 
	label="Editor" 
	name="editors" 
	id="entry_id_editor" 
	placeholder="Editor" 
	style="width:50%" 
	empty=true 
	optgroup=false 
	data="editors"
	value=$entry.map.editors
	can_edit=$can.edit
}

{include
	file="checkbox.tpl"
	label="Beats"
	name="beats[]"
	id="entry_id_beat_"
	data=$beats
	value=$entry.map.beats
	can_edit=$can.edit
}

{include
	file="checkbox.tpl"
	label="Regions"
	name="regions[]"
	id="entry_id_region_"
	data=$regions
	value=$entry.map.regions
	can_edit=$can.edit
}

{if $can.star}
<hr/>
You're logged in as an admin.

<input 
	id="id_star_this_item" 
	{if $entry.is_starred=='Yes'}checked="checked"{/if} 
	type="checkbox" 
	name="star" 
/><label for="id_star_this_item">&nbsp;Highlight this item for others (will show up on top lists).</label>

{else}

		<div class="form-group insights_star_note">
			<label class="col-sm-2 control-label">&nbsp;</label>
			<div class="col-sm-10">
{if $entry.is_starred == 'Yes'}
				<div class="insights_star_note_starred">
					<span class="glyphicon glyphicon-star"></span>
					<span>This entry is highlighted and will show up on top lists.</span>
				</div>
{else}
				<div class="insights_star_note_empty">
					<span class="glyphicon glyphicon-star-empty"></span>
					<span>This entry is not highlighted by an assignment editor, and will not show up on top lists.</span>
				</div>
{/if}
			</div>
		</div>
		

{/if}
	<hr/>

	<div class="form-group">
			<label class="col-sm-2 control-label">&nbsp;</label>
			<div class="col-sm-10">
{if $can.edit}
				<button
					id="id_update_new_insight"
					name="update_insight"
					type="submit"
					class="btn btn-default"
				>Update insight</button>
{else}
				<button 
					onclick="window.location='?{rewrite erase='edit'}{/rewrite}'" 
					type="button" 
					class="btn btn-cancel"
				>Go Back</button>

{/if}

{if $can.delete}
				<button 
					type="button" 
					class="btn btn-default deletion_button" 
					record-id="{$entry.id}"
					deletion-target="?{rewrite delete=$entry.id}{/rewrite}"
				>Delete Insight</button>
{/if}

{if $entry.is_deleted == 'Yes'}
<span class="insights_star_note_empty">
	Note: This item is deleted. To undelete, click 'update'.
</span>
{/if}

			</div>
	</div>
		
	</form>
	
</div>


</div>


{/block}
