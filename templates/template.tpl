<!DOCTYPE html>
<html>
<head>
{include file="title.tpl"}

<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<meta name="robots" content="noindex" />

{$screen = "screen"}{$print = "print"}

<link media="{$screen}" href="{$base_url}js/bootstrap-3.0.2/css/bootstrap.min.css" rel="stylesheet" />
<link media="{$screen}" href="{$base_url}js/bootstrap-datepicker/css/datepicker.css" rel="stylesheet" />
<link media="{$screen}" href="{$base_url}js/bootstrap-select2-3.4.5/select2.css" rel="stylesheet" />
<link media="{$screen}" href="{$base_url}js/bootstrap-sortable/Contents/bootstrap-sortable.css" rel="stylesheet" />
<link media="{$screen}" href="{$base_url}insights.css?v={$version|default:1}" rel="stylesheet" />
<link media="{$print}" href="{$base_url}print.css?v={$version|default:1}" rel="stylesheet" />

<link rel="shortcut icon" type="image/x-icon" href="{$base_url}favicon.ico" />

<!--[if lt IE 9]>
<script src="https://oss.maxcdn.com/libs/html5shiv/3.7.0/html5shiv.js"></script>
<script src="https://oss.maxcdn.com/libs/respond.js/1.3.0/respond.min.js"></script>
<![endif]-->

{block name='head'}
{/block}

</head>

<body class="{$theme|default:'theme_default'}">

{include file='nav.tpl'}

<div class="clearfix"></div>

{if !$is_admin}
<div class="container container_add_insight">
{include file='add_insight.tpl'}
</div>
<div class="clearfix"></div>
{/if}

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

<script src="{$base_url}js/bootstrap-jquery/jquery.js"></script>
<script src="{$base_url}js/jquery.cookie.js"></script>
<script src="{$base_url}js/bootstrap-3.0.2/js/bootstrap.min.js"></script>
<script src="{$base_url}js/bootstrap-datepicker/js/bootstrap-datepicker.js"></script>
<script src="{$base_url}js/bootstrap-select2-3.4.5/select2.min.js"></script>
<script src="{$base_url}js/rainbowvis-js/rainbowvis.js"></script>
<script src="{$base_url}js/bootstrap-sortable/Scripts/bootstrap-sortable.js"></script>
<script src="{$base_url}js/bootstrap-sortable/Scripts/moment.min.js"></script>
<script src="{$base_url}js/isotope/isotope.pkgd.min.js"></script>
<script src="{$base_url}js/jquery.highlight.js"></script>

{if !$is_admin}
{include file="_data.tpl"}
<script type="text/javascript" src="{$base_url}columns.js?v={$version|default:1}"></script>
<script type="text/javascript" src="{$base_url}insights.js?v={$version|default:1}"></script>
<script type="text/javascript" src="{$base_url}watchlist.js?v={$version|default:1}"></script>
{/if}

<!-- footer block -->

{block name='footer'}{/block}

<!-- end footer block -->

{if $disable_footer}
<!-- additional footer disabled -->
{else}
{$config.footer.value}
{/if}

</body>

</html>
