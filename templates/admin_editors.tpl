{extends file='admin.tpl'}

{block name='content' append}

{include file='admin__table.tpl' merge=true rename=true list='editors' table_title='Editors' add=false editable=false hide=array('is_deleted') data=$editors}

{/block}