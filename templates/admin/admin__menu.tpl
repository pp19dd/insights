
<br/>

<nav class="navbar navbar-default" role="navigation">
    <ul class="nav navbar-nav">
        <li class="{if $smarty.get.page == 'divisions'}active{/if}"><a href="{$base_url}admin/divisions/">Divisions</a></li>
        <li class="{if $smarty.get.page == 'services'}active{/if}"><a href="{$base_url}admin/services/">Services</a></li>
        <li class="{if $smarty.get.page == 'beats'}active{/if}"><a href="{$base_url}admin/beats/">Beats</a></li>
        <li class="{if $smarty.get.page == 'reporters'}active{/if}"><a href="{$base_url}admin/reporters/">Reporters</a></li>
        <li class="{if $smarty.get.page == 'editors'}active{/if}"><a href="{$base_url}admin/editors/">Editors</a></li>
        <li class="{if $smarty.get.page == 'cameras'}active{/if}"><a href="{$base_url}admin/cameras/">Cameras</a></li>
        <li class="{if $smarty.get.page == 'activity'}active{/if}"><a href="{$base_url}admin/activity/">Activity Log</a></li>
        <li class="{if $smarty.get.page == 'elasticsearch'}active{/if}"><a href="{$base_url}admin/elasticsearch/">Elastic Search</a></li>
    </ul>
</nav>
