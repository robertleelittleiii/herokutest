/* 
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */




function ajaxSave()
{
    
    tinyMCE.triggerSave();

    $j("#slider_slider_content_save").closest("form").trigger("submit");

}

$j(document).ready(function(){
    
    $j('#slider_slider_content_save').bind("click", function() {
        $j(this).closest("form").trigger("submit");
        return true;
    });
    
});

