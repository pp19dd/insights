{extends file='template.tpl'}


{block name='content'}

<h2>404 error: page not found</h2>

<p><strong>URL: </strong>{$base_url}{$smarty.server["REQUEST_URI"]|ltrim:"/"}</p>

<p>If you believe you're seeing this page in error, please contact an administrator.</p>

{/block}
