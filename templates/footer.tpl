
<footer>

{if $can.logout}
	<div class="pull-right">
		{if $can.star}<a href="{$base_url}admin/">Control Panel</a> | {/if}
		Logged in as {if $can.star}Admin{else}Regular User{/if} | <a href="?{rewrite logout=1}{/rewrite}">Logout</a>
	</div>

{/if}

{if $can.login}
	<div class="pull-right">
		<form method="post" action="?{rewrite login=1 erase='logout'}{/rewrite}">
		Password:
		<input type="password" id="id_password" name="password" />
		<input type="submit" name="do_login" value="Login"/>
		</form>
	</div>
{/if}

<div>
	<p>
		<span class="insights_version">Version {$version}</span>. 
		Problems, questions? Contact <a href="mailto:voadigital@voanews.com?subject=VOA%20Insights">voadigital@voanews.com</a>
	</p>
</div>

</footer>
