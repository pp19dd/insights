
{if isset($elasticsearch_results)}

{function name="aggregations"}
<div class="aggregation">
<h5>{$title}</h5>
<ul>
{foreach from=$field.buckets item=bucket}
<li>{$bucket.key} ({$bucket.doc_count})</li>
{/foreach}
</ul>
</div>
{/function}

{*<!--
<pre>{$elasticsearch_results.exact.aggregations|print_r}</pre>

beats: 4
mediums: 3
services: 7
divisions: 6
editors: 6
reporters: 10
regions: 9

-->*}

<div class="panel panel-lg aggregations">
    {aggregations title="Beats" field=$elasticsearch_results.exact.aggregations.beats}
    {aggregations title="Mediums" field=$elasticsearch_results.exact.aggregations.mediums}
    {aggregations title="Services" field=$elasticsearch_results.exact.aggregations.services}
    {aggregations title="Divisions" field=$elasticsearch_results.exact.aggregations.divisions}
    {aggregations title="Editors" field=$elasticsearch_results.exact.aggregations.editors}
    {aggregations title="Reporters" field=$elasticsearch_results.exact.aggregations.reporters}
    {aggregations title="Regions" field=$elasticsearch_results.exact.aggregations.regions}
</div>

{*<!--
<div style="clear:both"></div>

<div style="color:red">
    DEBUG--<br/>
{foreach from=$elasticsearch_results.exact.aggregations key=aggregation_name item=aggregation}
{$aggregation_name}: {$aggregation.buckets|count}<br/>
{/foreach}
</div>

<div style="clear:both"></div>
-->*}

{/if}
