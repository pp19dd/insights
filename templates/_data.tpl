
{if $can.view == true}

var insights_data = {
	editors: { results: {$editors_reduced|json_encode} },
	reporters: { results: {$reporters_reduced|json_encode} },
	activity: {$activity|json_encode},
	entry: {if isset($entry)}{$entry|json_encode}{else}null{/if}
};

{else}

var insights_data = {
	editors: { results: [] },
	reporters: { results: [] },
	activity: {
		"list":{ },
		"range":{ "min":"0","max":"1" }
	},
	entry: null
};



{/if}