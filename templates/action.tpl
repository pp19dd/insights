
{if isset($entry_added) or isset($entry_updated)}

{$entry_id = $entry_added.returned.entries|array_shift}

<div class="alert alert-success alert-dismissable">

	<button type="button" class="close" data-dismiss="alert" aria-hidden="true">&times;</button>
	
	<p>
		<span>Entry {if isset($entry_updated) and $entry_updated}updated{else}added{/if}: {$entry_added.posted.slug|default:"Untitled"}.</span>
		<a class="alert-link" href="?{rewrite edit=$entry_id}{/rewrite}">Edit</a>{*<!-- | 
		<a class="alert-link" href="?delete={$entry_id}">Delete</a>-->*}
	</p>

</div>

{/if}

{if isset($smarty.get.deleted)}

<div class="alert alert-success alert-dismissable">

	<button type="button" class="close" data-dismiss="alert" aria-hidden="true">&times;</button>
	
	<p>
		<span>Entry # {$smarty.get.deleted} Deleted.</span>
		<a class="alert-link" href="?{rewrite edit=$smarty.get.deleted erase=deleted}{/rewrite}">Edit to undelete</a>
	</p>

</div>

{/if}
