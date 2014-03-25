{extends file='admin.tpl'}

{block name='content' append}

{include file='admin__table.tpl' list='reporters' table_title='Reporters' add=false editable=false hide=array('is_deleted') data=$reporters}

{/block}
