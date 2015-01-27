{extends file='admin/admin.tpl'}

{block name='head' append}
<style type="text/css">
.activity_log { padding: 10px }
.activity_log h5 { text-align: right; color: crimson; font-weight: bold; opacity:0.5;}
.activity_log td { padding:5px; text-align: right }
.activity_action td { }
.activity_numbers td { font-size: 18px; font-weight: bold; color: gray; }
.activity_log td { border-right: 1px dotted silver }
.activity_log td.last { border-right: 0 }

.activity_entries { width: 100% }
.activity_entries hr { border-top:3px solid black }
.activity_entries td, .activity_entries th { font-size:12px; }
.activity_entries .stamp { white-space: nowrap; padding-right:15px; }
.activity_entries .stamp, .activity_entries .ip { color: gray }
.activity_entries .week { text-align: center }

.search { width: 450px; float: right; margin-top:14px; }
.search label { display: inline; width:50px; font-size:12px; }
.search input { width: 75px; display: inline; }

</style>
{/block}

{block name='content' append}

{function name="search"}
<form method="get">
<div class="search">
	<label>ip:</label> <input type="text" autocomplete="off" name="ip" value="{if isset($smarty.get.ip)}{$smarty.get.ip|trim}{/if}" />
	<label>id:</label> <input type="text" autocomplete="off" name="id" value="{if isset($smarty.get.id)}{$smarty.get.id|trim}{/if}"/>
	<label>slug:</label> <input type="text" autocomplete="off" name="slug" value="{if isset($smarty.get.slug)}{$smarty.get.slug|trim}{/if}"/>
	<label></label> <input type="submit" name="find" value="find" />
</div>
</form>
{/function}

{function name="pagination"}

{if $history_pages.list|count > 1}
<hr/>
<div class="btn-group btn-group-sm">
{foreach from=$history_pages.list item=page}
	<div
		class="btn btn-default {if $page == $history_pages.current}active{/if}"
		onclick="window.location='{strip}
		?{rewrite erase="mode,page" p=$page}{/rewrite}
		{/strip}';">
		{$page}
	</div>
{/foreach}
</div>
<hr/>
{/if}
{/function}

{function name="counts"}
<div class="activity_log">
	{*<h5>{$history_rows|number_format} Actions</h5>*}
	<table>
		<tr class="activity_numbers">
			<td class="last">Add</td>
			<td>{$history_actions.add.rows|number_format}</td>
			<td class="last">Update</td>
			<td>{$history_actions.update.rows|number_format}</td>
			<td class="last">Delete</td>
			<td>{$history_actions.delete.rows|number_format}</td>
			<td class="last">Star</td>
			<td class="last">{$history_actions.star.rows|number_format}</td>
		</tr>
	</table>
</div>
{/function}

{function name="row_break"}
<tr>
	<td colspan="5">
		<table width="100%">
			<tr>
				<td width="40%"><hr/></td>
				<td class="week">Week ending with {$stamp|date_format:"Y-m-d"}</td>
				<td width="40%"><hr/></td>
			</tr>
		</table>
	</td>
</tr>
{/function}

<div>
{search}
{counts}
{pagination}
</div>

<table class="activity_entries">
	<thead>
		<tr>
			<th class="stamp">stamp</th>
			<th>IP address</th>
			<th>Action Taken</th>
			<th>Content ID</th>
			<th>SLUG</th>
		</tr>
	</thead>
{foreach from=$history_entries item=entry}
{if $entry@first}
{assign var="prev" value=$entry.stamp}
{/if}
{if $entry.stamp|date_format:"W" != $prev|date_format:"W"}{row_break stamp=$entry.stamp week=$entry.stamp|date_format:"W"}{/if}
	<tr>
		<td class="stamp">{$entry.stamp}</td>
		<td class="ip">{$entry.ip}</td>
		<td>{$entry.action}</td>
		<td>
			<a href="{$base_url}?edit={$entry.entry_id}">{$entry.entry_id}</a>
		</td>
		<td>{$entry.slug}</td>
	</tr>
{assign var="prev" value=$entry.stamp}
{/foreach}
</table>

{/block}
