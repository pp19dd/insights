
<form class="" action="http://localhost/insights/?" method="get">
<table width="100%">
    <tr>
        <td>
            <input
                type="text"
                autocomplete="off"
                name="keywords"
                id="search_form_search"
                placeholder="Search keywords"
                value="{if isset($smarty.get.keywords)}{$smarty.get.keywords}{/if}"
            ></td>
        <td style="width:100px"><input type="submit" value="Search" name="search" style="margin-right:10px"></td>
    </tr>
    </table>
</form>

<div class="clearfix"></div>
