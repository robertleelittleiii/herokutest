/* 
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

function activate_scroller_sort () {
    
    $j('#sliders').sortable({
        axis: 'y',
        dropOnEmpty: false,
        handle: '.slider-drag',
        cursor: 'crosshair',
        items: 'li',
        opacity: 0.4,
        scroll: true,
        update: function(){
            page_id = $j("#page-id").html().trim();

            $j.ajax({
                type: 'post',
                data: $j('#sliders').sortable('serialize') + "&page_id=" + page_id ,
                dataType: 'script',
                complete: function(request){
                    $j('#sliders').effect('highlight');
                },
                url: '/sliders/sort'
            })
        }
    });    
}

function set_up_add_slider_callback() {
    
    $j("#add-slider")
    .bind("ajax:success", function(event, data, status, xhr) {
        page_id = $j("#page-id").html().trim();
        $j.ajax({
            type: 'POST',
            data: 'page_id='+page_id ,
            dataType: 'html',
            success: function(data){
                $j('ul#sliders').html(data);
                activate_scroller_sort();
                set_up_delete_slider_callback();

                
            },
            url: '/pages/get_sliders_list'
        })
    });
}

function set_up_delete_slider_callback() {
    
    $j(".delete_slider")
    .bind("ajax:success", function(event, data, status, xhr) {
        page_id = $j("#page-id").html().trim();
        $j.ajax({
            type: 'POST',
            data: 'page_id='+page_id ,
            dataType: 'html',
            success: function(data){
                $j('ul#sliders').html(data);
                activate_scroller_sort();
                set_up_delete_slider_callback();
            },
            url: '/pages/get_sliders_list'
        })
    });
    
}


$j(document).ready(function(){

    activate_scroller_sort();
    set_up_delete_slider_callback();
    set_up_add_slider_callback();

    $j('#page_body_save').bind("click", function() {
        alert("clicked");
        $j(this).closest("form").trigger("submit");
        return true;
    });
    
});

function ajaxSave()
{
    
    tinyMCE.triggerSave();

    $j("#page_body_save").closest("form").trigger("submit");

}

