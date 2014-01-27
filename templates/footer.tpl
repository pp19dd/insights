
<footer>

{if $can.logout}
	<div class="pull-right">
		Logged in as Admin <a href="?{rewrite logout=1}{/rewrite}">Logout</a>
	</div>
{/if}

{if $can.login}
	<div class="pull-right">
		<form method="post" action="?{rewrite login=1 erase='logout'}{/rewrite}">
		Admin
		<input type="password" id="id_password" name="password" />
		<input type="submit" name="do_login" value="Login"/>
		</form>
	</div>
{/if}

	<p>Problems, questions? Contact <a href="mailto:voadigital@voanews.com?subject=VOA+Insights">voadigital@voanews.com</a></p>
</footer>
