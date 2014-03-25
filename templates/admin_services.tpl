{extends file='admin.tpl'}

{block name='content' append}

{include file='admin__table.tpl' list='services' table_title='VOA Services' add=false editable=false hide=array('is_deleted', 'division_id') data=$services}

{/block}
