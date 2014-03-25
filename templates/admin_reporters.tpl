{extends file='template.tpl'}

{block name='footer'}
{/block}

{block name='menu'}
<a class="navbar-brand" href='{$base_url}?'>&gt;&nbsp;{$today|date_format:"M d, Y"}</a>
<a class="navbar-brand" href='{$base_url}admin/'>&gt;&nbsp;Admin</a>
{/block}

{block name='content'}

{include file='admin__menu.tpl'}
{include file='admin__table.tpl' list='reporters' table_title='Reporters' add=false editable=false hide=array('is_deleted') data=$reporters}

{/block}
