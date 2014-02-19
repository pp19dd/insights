
<div class="container clearfix" style="margin-bottom:1em">
	<div class="pull-right">
		<a href="#" onclick="$('#id_history').slideToggle('fast'); return(false);">Change Log</a>
	</div>
</div>

<div class="container clearfix ">
	<div class="panel panel-default" id="id_history" style="xdisplay:none">
		<div class="panel-body">

<div style="height:300px; overflow-y:auto">
			
<table class="table">
<thead>
<tr>
	<td style="width:175px">Date/Time</td>
	<td style="width:300px">IP Address</td>
	<td style="width:175px">Action</td>
	<td>Note</td>
</tr>
</thead>
<tbody>
{foreach from=$history.history item=row}
<tr>
	<td>{$row.stamp}</td>
	<td>{$row.ip}</td>
	<td>{$row.action|capitalize}</td>
	<td>{$row.note}</td>
</tr>
{/foreach}
</tbody>
</table>

</div>

		</div>
	</div>
</div>