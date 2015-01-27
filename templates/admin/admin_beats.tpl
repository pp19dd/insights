{extends file='admin/admin.tpl'}

{block name='content' append}

{include file='admin/admin__table.tpl' table_title='Beats' add=false editable=false hide=array('is_deleted') data=$beats}

{/block}
