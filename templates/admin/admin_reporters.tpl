{extends file='admin/admin.tpl'}

{block name='content' append}

{include file='admin/admin__table.tpl' merge=true rename=true list='reporters' table_title='Reporters' add=false editable=false hide=array('is_deleted') data=$reporters}

{/block}
