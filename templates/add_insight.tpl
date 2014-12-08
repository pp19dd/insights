
{if $can.edit == false}

<div class="container" id="{$id|default:'id_add_entry'}">

	<p>Sorry, you can't add or edit entries from outside of the VOA network.</p>
	<p>To request remote access, please contact 
		<a href="mailto:voadigital@voanews.com?subject=VOA+Insights">voadigital@voanews.com</a>
	</p>

</div>

{else}

<div class="container" id="{$id|default:'id_add_entry'}">

	<form role="form" class="form-horizontal" method="post">
		<input type="hidden" name="form_type" value="add_insight" />
		<div class="form-group">
			<label for="input_slug" class="col-sm-2 control-label">Slug</label>
			<div class="col-sm-10">
				<input 
					name="slug" 
					type="text" 
					autocomplete="off" 
					class="form-control" 
					id="input_slug" 
					placeholder="Insight slug" />
			</div>
		</div>
		<div class="form-group">
			<label for="input_slug" class="col-sm-2 control-label">Description</label>
			<div class="col-sm-10">
				<textarea 
					name="description" 
					class="form-control" 
					id="input_description" 
					placeholder="Longer description of the story"
				></textarea>
			</div>
		</div>

{capture assign=camera_equipment}
		<label class="checkbox-inline insights_checkbox_label" style="margin-left:70px">
			<input 
				name="camera_assigned" 
				type="checkbox"
				class="insights_checkbox"
			><span class="glyphicon glyphicon-camera"></span> Camera equipment assigned 
		</label>
{/capture}
		
{include
	file="checkbox.tpl"
	label="Mediums"
	name="mediums[]"
	id="id_medium_"
	data=$mediums
	can_edit=$can.edit
	append_html=$camera_equipment
}

		<div class="form-group">
			<label for="input_deadline" class="col-sm-2 control-label">Deadline (date/time)</label>
			<div class="col-sm-10">

				<div id="id_entry_form_group_deadline_add">

				<input 
					name="deadline" 
					type="text" autocomplete="off" 
					class="form-control " 
					style="width:20%; float:left; margin-right:10px;" 
					id="input_deadline" 
					placeholder="{$range->actually_today|date_format:'Y-m-d'}"
				/>

Time

{include
	skip_container=true 
	mode=1
	file="select2.tpl" 
	label="Time" 
	name="deadline_time" 
	id="id_deadline_time" 
	style="width:20%;" 
	empty=true
	data=$hours
	can_edit=$can.edit
	can_clear=true
}

</div>

		<div class="clearfix"></div>

<div class="hold_for_release">
		<label class="checkbox-inline insights_checkbox_label" style="">
			<input 
				name="hold_for_release" 
				type="checkbox"
				parent="id_entry_form_group_deadline_add"
				class="insights_checkbox hold_for_release_checkbox"
			><span class="glyphicon glyphicon-pushpin"></span> No date, this is a Hold for Release entry 
		</label>
</div>

			</div>
		</div>
	
{include 
	mode=2
	file="select2.tpl" 
	label="Origin (Div/Svc)" 
	name="origin" 
	id="id_division_service" 
	placeholder="Select division / language service" 
	style="width:50%" 
	empty=true 
	optgroup=true 
	data=$divisions_and_services
	can_edit=$can.edit
	can_clear=true
}

{include 
	mode=3
	file="select2.tpl" 
	label="Reporter" 
	name="reporters" 
	id="id_reporter" 
	placeholder="Reporter (Last name, First)" 
	style="width:50%" 
	empty=true 
	optgroup=false 
	data="reporters"
	can_edit=$can.edit
}

{include 
	mode=3
	file="select2.tpl" 
	label="Editor" 
	name="editors" 
	id="id_editor" 
	placeholder="Editor (Last name, First)" 
	style="width:50%" 
	empty=true 
	optgroup=false 
	data="editors"
	can_edit=$can.edit
}

{include
	file="checkbox.tpl"
	label="Beats"
	name="beats[]"
	id="id_beat_"
	data=$beats
	can_edit=$can.edit
}

{include
	file="checkbox.tpl"
	label="Regions"
	name="regions[]"
	id="id_region_"
	data=$regions
	can_edit=$can.edit
}

	<hr/>

	<div class="form-group">
			<label class="col-sm-2 control-label">&nbsp;</label>
			<div class="col-sm-10">
				<button id="id_submit_new_insight" type="submit" class="btn btn-default">Save new insight</button>
				<button id="id_cancel_new_insight" type="button" class="btn btn-cancel">Cancel</button>
			</div>
	</div>
		
	</form>
	
</div>

{include file="action.tpl"}

{/if}