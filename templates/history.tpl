
<style>
.diff_col1 { font-size:10px; color:silver }
.diff_col2 { font-size:10px }
</style>

{function name=diffrow}
<tr class="diff_{$key}">
	<td class="diff_col1">{$a}</td>
	<td class="diff_col2">{$b}</td>
</tr>
{/function}


{function name=entry}
{diffrow key="slug" a="slug" b=$entry.slug}
{diffrow key="description" a="description" b=$entry.slug}
{diffrow key="deadline" a="deadline" b=$entry.slug}
{/function}

{function name=map}
{foreach from=$map key=key item=item}
{diffrow key=$key a=$key|capitalize b=$item}
{/foreach}

{/function}

<div class="container clearfix" style="margin-bottom:1em">
	<div class="pull-right">
		<a href="#" onclick="$('#id_history').slideToggle('fast'); return(false);">Change Log</a>
	</div>
</div>

<div class="container clearfix ">
	<div class="panel panel-default" id="id_history" style="xdisplay:none">
		<div class="panel-body" style="background-color:#F7F2F7">

<div style="height:300px; overflow-y:auto">
			
<table class="table">
<thead>
<tr>
	<td style="width:175px">Date/Time</td>
	<td style="width:200px">IP Address</td>
	<td style="width:175px">Action</td>
	<td>Note</td>
</tr>
</thead>
<tbody>
{foreach from=$history.history item=row}
<tr class="history_row_{$row.action}">
	<td>{$row.stamp}</td>
	<td>{$row.ip}</td>
	<td>{$row.action|capitalize}</td>
	<td>
{if $row.action == 'update' and isset($row.entry)}
<table>
{entry entry=$row.entry}
{map map=$row.simple}
</table>
{else}
{$row.note}
{/if}</td>
</tr>
{/foreach}
</tbody>
</table>

</div>

		</div>
	</div>
</div>