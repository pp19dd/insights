
<!-- rename modal -->
<div class="modal fade" id="renameModal" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
	<div class="modal-dialog">
		<div class="modal-content">
			<div class="modal-header">
				<button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
				<h4 class="modal-title" id="myModalLabel">Rename this term?</h4>
			</div>
			<div class="modal-body">
				<ul>
					<li>Term id: <span id="renameModal_term_id"></span></li>
					<li>Term type: <span id="renameModal_term_type"></span></li>
					<li>Term name: <span id="renameModal_term_name"></span></li>
				</ul>

				New name: <input id="renameModal_term_name_new" type="text" autocomplete="off" style="width:300px" />
			</div>
			<div class="modal-footer">
				<div class="pull-left alert" id="renameModal_alert"></div>
				<button type="button" id="renameModal_button_close" class="btn btn-default" data-dismiss="modal">Close</button>
				<button type="button" id="renameModal_button_rename" class="btn btn-primary" onclick="do_rename_term()">Rename</button>
			</div>
		</div>
	</div>
</div>
