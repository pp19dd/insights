
{if isset($elasticsearch_results) && isset($elasticsearch_results.exact) && isset($elasticsearch_results.exact.aggregations)}
{if isset($smarty.get.day) && $smarty.get.day == "HFR"}

{elseif isset($smarty.get.day) && $smarty.get.day == "watchlist"}

{elseif isset($smarty.get.edit)}

{else}

{function name="aggregations"}
<div class="aggregation">
    <h5>{$title}</h5>
    <ul>
{foreach from=$field.buckets item=bucket}
{if isset($lookup[$bucket.key])}
        <li>
            <a href="?keywords={aggregate input=$smarty.get.keywords|default:"" prefix=$search add=$lookup[$bucket.key].name}{/aggregate}&search=Search">
                {$lookup[$bucket.key].name}
                <span class="insights_entry_count">{$bucket.doc_count}</span>
            </a>
        </li>
{/if}
{/foreach}
    </ul>
</div>
{/function}

<div class="panel panel-lg aggregations">
    <div class="aggregation">
        <h5>Deadline</h5>
        <ul>
{if !isset($smarty.get.keywords)}
            <li>Showing today's date.</li>
            <li><a href="?search=search&amp;keywords=date:{$range->day->today}">Share permalink.</a></li>
            <li>&nbsp;</li>
{/if}
            <li><a href="?search=search&keywords=date:{$range->day->prev->today}">Prev: {$range->day->prev->today}</a></li>
            <li><a href="#" class="pick_date_exact" id="id_range_from" data-date="{$range->actually_today}" data-date-format="yyyy-mm-dd">Choose Date</a></li>
            <li><a href="?search=search&keywords=date:{$range->day->next->today}">Next: {$range->day->next->today}</a></li>
        </ul>
    </div>
    {*<!--{aggregations title="Divisions" lookup=$divisions field=$elasticsearch_results.exact.aggregations.divisions}-->*}
    {aggregations title="Origin"    lookup=$services  field=$elasticsearch_results.exact.aggregations.services  search="origin:"}
    {aggregations title="Mediums"   lookup=$mediums   field=$elasticsearch_results.exact.aggregations.mediums   search="medium:"}
    {aggregations title="Beats"     lookup=$beats     field=$elasticsearch_results.exact.aggregations.beats     search="beat:"}
    {aggregations title="Regions"   lookup=$regions   field=$elasticsearch_results.exact.aggregations.regions   search="region:"}
    {aggregations title="Reporters" lookup=$reporters field=$elasticsearch_results.exact.aggregations.reporters search="reporter:"}
    {aggregations title="Editors"   lookup=$editors   field=$elasticsearch_results.exact.aggregations.editors   search="editor:"}
    <div class="clearfix"></div>
</div>

{/if}
{/if}
