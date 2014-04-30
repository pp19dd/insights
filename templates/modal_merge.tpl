
<!-- merge modal -->
<div class="modal fade" id="mergeModal" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
	<div class="modal-dialog">
		<div class="modal-content">
			<div class="modal-header">
				<button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
				<h4 class="modal-title" id="myModalLabel">Merge these terms?</h4>
			</div>
			<div class="modal-body">
				<div id="merge_body"></div>
				<p class="merge_selection_status">&nbsp;</p>
				<div id="merge_debug"></div>
			</div>
			<div class="modal-footer">
				<div class="pull-left alert" id="renameModal_alert"></div>
				<button type="button" id="mergeModal_button_close" class="btn btn-default" data-dismiss="modal">Close</button>
				<button type="button" id="mergeModal_button_rename" class="btn btn-primary" onclick="do_merge_terms()">Merge</button>
			</div>
		</div>
	</div>
</div>
