/* 
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */


function addHasChildren(field_table)
{
    console.log(field_table);
    $j($j(field_table).find("table")[0]).removeClass("has-sub-menus")
    $j($j($j(field_table).find("table")[0]).parent().find("ul")[0]).slideDown();
    $j($j(field_table).find("img")[0]).attr("src",$j(field_table).find("img").attr("src").replace("closed", "open"));
    $j($j(field_table).find("img")[0]).attr("src",$j(field_table).find("img").attr("src").replace("disabled", "open"));

    $j.cookie('open_menu_list',$j.unique($j.merge($j.cookie('open_menu_list').split(","),[$j("#field_1").find("ul").first().attr("id")])));

}

function makeDraggable()
{  
    $j('.draggable_menu_item').sortable({
        axis: 'y',
        dropOnEmpty: false,
        handle: '.menu-drag',
        cursor: 'crosshair',
        items: 'div',
        opacity: 0.4,
        scroll: true,
        update: function(){
            $j.ajax({
                type: 'post',
                data: $j(this.getAttribute("data-id")).sortable('serialize'),
                dataType: 'script',
                complete: function(request){
                //$j('.draggable_menu_item').effect('highlight');
                },
                url: '/menus/update_order'
            })
        }
    });

}

function bindToggleListClick(item) {
    if (typeof item === 'undefined') 
    {
        var items_to_set_click = "a.lever-toggle"; 
    }
    else 
    {
        var items_to_set_click = item + " a.lever-toggle"; 
          
    }
            
    $j(items_to_set_click).click(function(){
        var parentTable = $j(this).parent().parent().parent().parent().parent();
        var this_id = $j(this).parent().parent().parent().parent().parent().next("ul").attr("id")
        
        if ($j.trim($j(parentTable).attr("class"))=="has-sub-menus")
        {
            $j(this).parent().parent().parent().parent().parent().next("ul").attr("id")

            $j.cookie('open_menu_list',$j.unique($j.merge($j.cookie('open_menu_list').split(","),[this_id])))
            $j(this).find("img").attr("src",$j(this).find("img").attr("src").replace("closed", "open"))
            $j($j(this).parent().parent().parent().parent().parent().parent().find("ul")[0]).slideDown();
            $j(this).parent().parent().parent().parent().parent().removeClass("has-sub-menus");
        } 
        else
        {
            if ($j.trim($j($j(this).parent().parent().parent().parent().parent().parent().find("ul")[0]).html()).length != 0)
            {
                var theList = $j.cookie('open_menu_list').split(",")
                theList.splice(theList.indexOf(this_id),1)
                $j.cookie("open_menu_list",theList)
            
                $j(this).find("img").attr("src",$j(this).find("img").attr("src").replace("open", "closed"))
                $j($j(this).parent().parent().parent().parent().parent().parent().find("ul")[0]).slideUp();
                $j(this).parent().parent().parent().parent().parent().addClass("has-sub-menus");  
            }
        }
        return(false);
    });   
}
function handleOpenedMenus() {
    theList = $j.cookie('open_menu_list').split(",");
    $j.each(theList, function(key, value) {
        if($j("#"+value).length > 0)
        {
            $j("#"+value).slideDown();
            $j($j("#"+value).parent().find("img")[0]).attr("src",$j($j("#"+value).parent().find("img")[0]).attr("src").replace("closed", "open"))
            $j($j("#"+value).parent().find("table")[0]).removeClass("has-sub-menus");
        }
    //alert(key + ': ' + value); 
    });
}
function bindDeleteMenu() {
    
    $j('.delete_menu').bind('ajax:success', function() {
        $j(this).parent().parent().parent().parent().parent().fadeOut();
        $j(this).parent().parent().parent().parent().parent().parent().find("ul").fadeOut();
        $j(this).parent().parent().parent().parent().parent().prev("div").hide();
        
    // $j(this).closest('table').fadeOut();
    // alert("deleted");
    })

}


$j(document).ready(function(){

    if (($j.cookie('open_menu_list') == null) || ($j.cookie('open_menu_list') == "")  )
    {
        $j.cookie('open_menu_list',"null");
    }
    handleOpenedMenus();
    bindDeleteMenu() ;
    bindToggleListClick();
    
    $j('.draggable_menu_item').sortable({
        axis: 'y',
        dropOnEmpty: false,
        handle: '.menu-drag',
        cursor: 'crosshair',
        items: 'div',
        opacity: 0.4,
        scroll: true,
        update: function(){
            $j.ajax({
                type: 'post',
                data: $j(this.getAttribute("data-id")).sortable('serialize'),
                dataType: 'script',
                complete: function(request){
                //  $j('.draggable_menu_item').effect('highlight');
                },
                url: '/menus/update_order'
            })
        }
    });

    $j("#alert").click(function() {
        alert(this.getAttribute("data-message"));
        return false;
    });
});