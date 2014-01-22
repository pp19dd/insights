{extends file='template.tpl'}

{block name='footer'}
{/block}

{block name='content'}

{*<!-- ------------------------------------------------------------------
       only show entries that contain $filter in map[$sort].resolved[name = $group]
       ------------------------------------------------------------------ -->*}
{function name=show_entry group='unknown' show_all=false count=false}

{if $count}
44
{else}

{foreach from=$entry.map[$group] item=possible}
{if $possible.resolved.name == $filter}

{if $show_all or $entry.is_starred == 'Yes'}

<li class="insights_entry insights_entry_id_{$entry.id} insights_entry_starred_{$entry.is_starred|lower}">
	<div class="insights_slug">
		<a href="?edit={$entry.id}">{$entry.slug|default:"(Untitled)"}</a>
	</div>
	<div class="insights_description">{$entry.description|default:"(Blank)"}</div>
</li>

{/if}

{/if}
{/foreach}

{/if}
{/function}

{*<!-- ------------------------------------------------------------------ -->*}

{function name=entries count=false}

{if $count}
{foreach from=$entries item=entry}
{show_entry entry=$entry filter=$filter group=$smarty.get.sort show_all=true count=true}
{/foreach}
{else}

<ul class="insights_entries">
{foreach from=$entries item=entry}
{show_entry entry=$entry filter=$filter group=$smarty.get.sort show_all=$show_all}
{/foreach}
</ul>

{/if}
{/function}

{include file="home_menu.tpl"}

{*<!-- ------------------------------------------------------------------
       show unstarred items
       ------------------------------------------------------------------ -->*}

{if $smarty.get.more}

<div class="row">

<h1>{$smarty.get.more}</h1>
<hr/>

{foreach from=$all_maps[$smarty.get.sort] key=key item=item}
{if $key == $smarty.get.more}

<div class="more_view">
{entries filter=$key show_all=true}
</div>

{/if}
{/foreach}

</div>


{else}

<div class="row">

{foreach from=$all_maps[$smarty.get.sort] key=key item=item}

	<div class="col-md-4">
		<h3>{$key|default:"(Unknown)"}</h3>
{entries filter=$key}
		<p><a class="btn btn-default" href="?{rewrite more=$key}{/rewrite}" role="button">View all ({entries filter=$key count=true}) &raquo;</a></p>
	</div>

{/foreach}

</div>

{/if}

<hr/>

{/block}
