<!DOCTYPE html>
<html>
<head>
<title>{$title|default:"VOA Insights"}</title>
<meta name="viewport" content="width=device-width, initial-scale=1.0">

{*<!--
<link href="/voa.lib/bootstrap-3.0.2/css/bootstrap.min.css" rel="stylesheet">
<link href="/voa.lib/bootstrap-libs/datepicker/css/datepicker.css" rel="stylesheet">
<link href="/voa.lib/bootstrap-select2/select2-3.4.5/select2.css" rel="stylesheet">
-->*}

<link href="bootstrap-3.0.2/css/bootstrap.min.css" rel="stylesheet">
<link href="bootstrap-datepicker/css/datepicker.css" rel="stylesheet">
<link href="bootstrap-select2-3.4.5/select2.css" rel="stylesheet">
<link href="bootstrap-sortable/Contents/bootstrap-sortable.css" rel="stylesheet">

<!--[if lt IE 9]>
<script src="https://oss.maxcdn.com/libs/html5shiv/3.7.0/html5shiv.js"></script>
<script src="https://oss.maxcdn.com/libs/respond.js/1.3.0/respond.min.js"></script>
<![endif]-->

{include file='_css.tpl'}

{block name='head'}
{/block}

</head>

<body class="{$theme|default:'theme_default'}">

{include file='nav.tpl'}

<div class="clearfix"></div>

<div class="container container_add_insight">
{include file='add_insight.tpl'}
</div>
<div class="clearfix"></div>

<div class="container container_content">
{block name='content'}{/block}
</div>
<div class="clearfix"></div>

<div class="container container_footer">
<br/>
<hr/>

{include file='footer.tpl'}

<hr/>
</div> <!-- /container -->

{*<!--
<script src="/voa.lib/bootstrap-jquery/jquery.js"></script>
<script src="/voa.lib/bootstrap-3.0.2/js/bootstrap.min.js"></script>
<script src="/voa.lib/bootstrap-libs/datepicker/js/bootstrap-datepicker.js"></script>
<script src="/voa.lib/bootstrap-select2/select2-3.4.5/select2.min.js"></script>
-->*}

<script src="bootstrap-jquery/jquery.js"></script>
<script src="bootstrap-3.0.2/js/bootstrap.min.js"></script>
<script src="bootstrap-datepicker/js/bootstrap-datepicker.js"></script>
<script src="bootstrap-select2-3.4.5/select2.min.js"></script>
<script src="rainbowvis-js/rainbowvis.js"></script>
<script src="bootstrap-sortable/Scripts/bootstrap-sortable.js"></script>
<script src="bootstrap-sortable/Scripts/moment.min.js"></script>

{include file='_javascript.tpl'}

{block name='footer'}{/block}

{if !$disable_footer}
{$config.footer.value}
{else}
<!-- additional footer disabled -->
{/if}

</body>
</html>