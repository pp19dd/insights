{extends file='admin.tpl'}

{block name='content' append}

{include file='admin__table.tpl' table_title='Beats' add=false editable=true hide=array('is_deleted') data=$beats}

{/block}
