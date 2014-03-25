{extends file='admin.tpl'}

{block name='content' append}

{include file='admin__table.tpl' list='divisions' table_title='VOA Divisions' add=false editable=false hide=array('is_deleted') data=$divisions}

{/block}
