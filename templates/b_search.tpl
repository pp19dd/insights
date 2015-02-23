
<form class="" action="http://{$base_url}/" method="get">

<table width="100%">
    <tr>
        <td>
            <input
                type="text"
                autocomplete="off"
                name="keywords"
                id="search_form_search"
                placeholder="Search keywords"
                class="form-control"
                value="{if isset($smarty.get.keywords)}{$smarty.get.keywords}{/if}"
            ></td>
        <td style="width:100px">
            <div class="btn-group">
                <input type="submit" value="Search" name="search" class="btn btn-default" style="margin-right:10px">
            </div>
        </td>
    </tr>
    </table>
</form>

<div class="clearfix"></div>
