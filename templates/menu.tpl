
<br/>

<nav class="navbar navbar-default" role="navigation">
    <ul class="nav navbar-nav">
		<li class="{if $smarty.get.mode == 'divisions'}active{/if}"><a href="{$base_url}admin/divisions/">Divisions</a></li>
		<li class="{if $smarty.get.mode == 'services'}active{/if}"><a href="{$base_url}admin/services/">Services</a></li>
		<li class="{if $smarty.get.mode == 'beats'}active{/if}"><a href="{$base_url}admin/beats/">Beats</a></li>
		<li class="{if $smarty.get.mode == 'reporters'}active{/if}"><a href="{$base_url}admin/reporters/">Reporters</a></li>
		<li class="{if $smarty.get.mode == 'editors'}active{/if}"><a href="{$base_url}admin/editors/">Editors</a></li>
	</ul>
</nav>
