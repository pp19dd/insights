{extends file='admin/admin.tpl'}

{block name='content' append}

{include file='admin/admin__table.tpl' list='divisions' table_title='VOA Divisions' add=false editable=false hide=array('is_deleted') data=$divisions}

{/block}
