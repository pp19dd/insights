{extends file='admin/admin.tpl'}

{block name='content' append}

{*
{include file='admin/admin__table.tpl' list='cameras' table_title='Cameras' add=false editable=false hide=array('is_deleted') data=$cameras}
*}

{include file="admin/table_entries.tpl" ids=$cameras|array_keys entries=$cameras custom_edit_link=true}

{/block}
