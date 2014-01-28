
{if $can.login}

<div class="container" id="{$id|default:'id_add_entry'}">

	<p>Sorry, you can't add or edit entries from outside of the VOA network.</p>
	<p>To request remote access, please contact <a href="mailto:voadigital@voanews.com?subject=VOA+Insights">voadigital@voanews.com</a></p>
</div>

{else}

<div class="container" id="{$id|default:'id_add_entry'}">

	<form role="form" class="form-horizontal" method="post">
		<input type="hidden" name="form_type" value="add_insight" />
		<div class="form-group">
			<label for="input_slug" class="col-sm-2 control-label">Slug</label>
			<div class="col-sm-10">
				<input name="slug" type="text" autocomplete="off" class="form-control" id="input_slug" placeholder="Insight slug">
			</div>
		</div>
		<div class="form-group">
			<label for="input_slug" class="col-sm-2 control-label">Description</label>
			<div class="col-sm-10">
				<textarea name="description" class="form-control" id="input_description" placeholder="Longer description of the story"></textarea>
			</div>
		</div>
		
		
{include
	file="checkbox.tpl"
	label="Mediums"
	name="medium[]"
	id="id_medium_"
	data=$mediums
}

		<div class="form-group">
			<label for="input_slug" class="col-sm-2 control-label">Deadline</label>
			<div class="col-sm-10">
				<input name="deadline" type="text" autocomplete="off" class="form-control " style="width:20%" id="input_deadline" placeholder="{$actually_today|date_format:'Y-m-d'}">
			</div>
		</div>
	
{include 
	file="select2.tpl" 
	label="Origin (Div/Svc)" 
	name="origin" 
	id="id_division_service" 
	placeholder="Select division / language service" 
	style="width:50%" 
	empty=true 
	optgroup=true 
	data=$divisions_and_services
}

{include 
	file="select2.tpl" 
	label="Reporter" 
	name="reporter" 
	id="id_reporter" 
	placeholder="Reporter" 
	style="width:50%" 
	empty=true 
	optgroup=false 
	data="reporters"
}

{include 
	file="select2.tpl" 
	label="Editor" 
	name="editor" 
	id="id_editor" 
	placeholder="Editor" 
	style="width:50%" 
	empty=true 
	optgroup=false 
	data="editors"
}

{include
	file="checkbox.tpl"
	label="Beats"
	name="beat[]"
	id="id_beat_"
	data=$beats
}

{include
	file="checkbox.tpl"
	label="Regions"
	name="region[]"
	id="id_region_"
	data=$regions
}

	<hr/>

	<div class="form-group">
			<label class="col-sm-2 control-label">&nbsp;</label>
			<div class="col-sm-10">
				<button id="id_submit_new_insight" type="submit" class="btn btn-default">Add new insight</button>
				<button id="id_cancel_new_insight" type="button" class="btn btn-cancel">Cancel</button>
			</div>
	</div>
		
	</form>
	
</div>


{if isset($entry_added) or isset($entry_updated)}

{$entry_id = $entry_added.returned.entries|array_shift}

<div class="alert alert-success alert-dismissable">

	<button type="button" class="close" data-dismiss="alert" aria-hidden="true">&times;</button>
	
	<p>
		<span>Entry {if $entry_updated}updated{else}added{/if}: {$entry_added.posted.slug|default:"Untitled"}.</span>
		<a class="alert-link" href="?{rewrite edit=$entry_id}{/rewrite}">Edit</a>{*<!-- | 
		<a class="alert-link" href="?delete={$entry_id}">Delete</a>-->*}
	</p>

</div>

{/if}

{/if}