
{if isset($elasticsearch_results) && isset($elasticsearch_results.exact) && isset($elasticsearch_results.exact.aggregations)}

{function name="aggregations"}
<div class="aggregation">
    <h5>{$title}</h5>
    <ul>
{foreach from=$field.buckets item=bucket}
        <li>
            <a href="?keywords={aggregate input=$smarty.get.keywords prefix=$search add=$lookup[$bucket.key].name}{/aggregate}&search=Search">
                {$lookup[$bucket.key].name}
                <span class="insights_entry_count">{$bucket.doc_count}</span>
            </a>
        </li>
{/foreach}
    </ul>
</div>
{/function}

<div class="panel panel-lg aggregations">
    <div class="aggregation">
        <h5>Deadline</h5>
        <ul>
            <li>2015</li>
            <li>2014</li>
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
