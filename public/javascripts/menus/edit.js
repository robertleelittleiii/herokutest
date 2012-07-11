/* 
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */


function ajaxSave()
{
    
            tinyMCE.triggerSave();

            $j("#menu_rawhtml_save").closest("form").trigger("submit");

}



function initTinyMCE ()
{
    tinyMCE.init({
        browsers : "msie,gecko,safari",
        cleanup : true,
        cleanup_on_startup : true,
        convert_fonts_to_spans : true,
        convert_urls : false,
        editor_selector : 'mceEditor',
        extended_valid_elements : 'img[class|src|flashvars|border=0|alt|title|hspace|vspace|width|height|align|onmouseover|onmouseout|name|obj|param|embed|scale|wmode|salign|style],embed[src|quality|scale|salign|wmode|bgcolor|width|height|name|align|type|pluginspage|flashvars],object[align<bottom?left?middle?right?top|archive|border|class|classid|codebase|codetype|data|declare|dir<ltr?rtl|height|hspace|id|lang|name|style|tabindex|title|type|usemap|vspace|width]',
        external_link_list_url : 'myexternallist.js',
        mode : 'textareas',
        plugin_preview_height : '650',
        plugin_preview_pageurl : '../../../../../posts/preview',
        plugin_preview_width : '950',
        plugins : "media,autolink,lists,spellchecker,pagebreak,style,layer,table,save,advhr,curblyadvimage,advlink,emotions,iespell,inlinepopups,insertdatetime,preview,searchreplace,print,contextmenu,paste,directionality,fullscreen,noneditable,visualchars,nonbreaking,xhtmlxtras,template",
        relative_urls : false,
        theme : 'advanced',
        theme_advanced_buttons1 : "save,newdocument,|,bold,italic,underline,strikethrough,|,justifyleft,justifycenter,justifyright,justifyfull,|,styleselect,formatselect,fontselect,fontsizeselect",
        theme_advanced_buttons2 : "cut,copy,paste,pastetext,pasteword,|,search,replace,|,bullist,numlist,|,outdent,indent,blockquote,|,undo,redo,|,link,unlink,anchor,image,cleanup,help,code,|,insertdate,inserttime,preview,|,forecolor,backcolor",
        theme_advanced_buttons3 : "tablecontrols,|,hr,removeformat,visualaid,|,sub,sup,|,charmap,emotions,iespell,media,advhr,|,print,|,ltr,rtl,|,fullscreen",
        theme_advanced_buttons4 : "insertlayer,moveforward,movebackward,absolute,|,styleprops,spellchecker,|,cite,abbr,acronym,del,ins,attribs,|,visualchars,nonbreaking,template,blockquote,pagebreak,|,insertfile,insertimage",
        theme_advanced_layout_manager : 'SimpleLayout',
        theme_advanced_resize_horizontal : false,
        theme_advanced_resizing : false,
        theme_advanced_statusbar_location : 'bottom',
        theme_advanced_toolbar_align : 'left',
        theme_advanced_toolbar_location : 'top'
    });

}


$j(document).ready(function(){
    var toggleLoading = function() {
        $j("#loader_progress").toggle()
        };
    var toggleAddButton= function() {
        $j("#upload-form").toggle()
        };

    //
    //
    // image class bindings
    // 

    $j('input#image').bind("change", function() {
        //       alert("changed");
        toggleLoading();
        toggleAddButton();
        $j(this).closest("form").trigger("submit");
    });
    
    //
    // delete image bindings
    //
    //
    //    $j('.delete_image').bind('ajax:before', function(){
    //        //     window.alert("before");
    //             toggleLoading();
    //    }) 
    //    .bind('ajax:complete', function(){
    //         //     window.alert("after");
    //
    //            toggleLoading();
    //    })
    //    .bind('ajax:success', function() {  
    // //           window.alert("test");
    //             $j(this).closest('.imageSingle').fadeOut();
    //             if ($j(".imageSingle").length < 9) then
    //                 {
    //                     $j("div#imagebutton").fadeIn();
    //
    //                 };
    //        });  
    //
    // upload form bindings
    //
    //
    $j('.upload-form').bind('ajax:before', function(){
        window.alert("before");
    // toggleLoading();
    }) 
    .bind('ajax:complete', function(){
        window.alert("after");

    //      toggleLoading();
    })
    .bind('ajax:success', function(event, data, status, xhr) {
        //$("#response").html(data);
        window.alert("success");
    });
    
    //
    // upload form bindings
    //
    //
    $j('.test-form').bind('ajax:before', function(){
        window.alert("before");
    // toggleLoading();
    }) 
    .bind('ajax:complete', function(){
        window.alert("after");

    //      toggleLoading();
    })
    .bind('ajax:success', function(event, data, status, xhr) {
        //$("#response").html(data);
        window.alert("success");
    })
    .bind('xhr.upload.onloadstart', function(event, data, status, xhr) {
        //$("#response").html(data);
        window.alert("success");
    })
    .bind('xhr.upload.onload', function(event, data, status, xhr) {
        //$("#response").html(data);
        window.alert("success");
    })
    .bind('xhr.upload.onerror', function(event, data, status, xhr) {
        //$("#response").html(data);
        window.alert("success");
    })
    .bind('xhr.upload.onabort', function(event, data, status, xhr) {
        //$("#response").html(data);
        window.alert("success");
    });
    
    
    $j("#menu_m_type").bind("change", function() {
        selected_item= $j("#menu_m_type option:selected");
        //alert(this.getAttribute("data-id"));


        $j.ajax({
            url: "/menus/ajax_load_partial",
            dataType: "html",
            type: "POST",
            data: "id="+this.getAttribute("data-id")+ "&partial_type="+selected_item.text() ,
            success: function (data)
            {
                //alert(data);
                if (data === undefined || data === null || data === "")
                {
                //display warning
                }
                else
                {
                    $j("#menu-options").html(data);
                    $j(".best_in_place").best_in_place();
                    initTinyMCE();
                }
            }
        });
     

    /*       switch (selected_item.attr("value"))
        {
          case "1":
               {

   /*                   $j('#menu-options').replaceWith($j.ajax({
                        url: "/menus/ajax_load_partial",
                        dataType: "html",
                        type: "POST",
                        data: "partial_type="+selected_item.text() }));
*/
    //alert(selected_item.text());

    /*               $j.ajax({
                        url: "/menus/ajax_load_partial",
                        dataType: "html",
                        type: "POST",
                        data: "partial_type="+selected_item.text() ,
                        success: function (data)
                        {
                            //alert(data);
                            if (data === undefined || data === null || data === "")
                            {
                                //display warning
                            }
                            else
                            {
                                $j("#menu-options").html(data);
                            }
                        }
                    });
break;
                }
                    
            /*        $j('#menu-options').replaceWith($j.ajax({
                        url: "/menus/ajax_load_partial",
                        dataType: "html",
                        type: "POST",
                        data: "partial_type="+selected_item.text() }));
*/
    /*

            case "2":
            {
                alert("html");
                break;
            }
            case "3":
            {
                alert("stuff");
                break;
            }
            default:
            {
                alert("unknown");
                break;
            }
        };

*/
    });
    
   
});




/*  $("#spinner").show(); // show the spinner
  var form = $(this).parents("form"); // grab the form wrapping the search bar.
  var url = form.attr("action"); // grab the URL from the form's action value.
  var formData = form.serialize(); // grab the data in the form
  $.get(url, formData, function(html) { // perform an AJAX get, the trailing function is what happens on successful get.
    $("#spinner").hide(); // hide the spinner
    $("#results").html(html); // replace the "results" div with the result of action taken


 switch (red) {
case 1: result = 'one'; break;
case 2: result = 'two'; break;
default: result = 'unknown';
}
docum
 *
 *
 *
 *
 *
 *
 *
 *
 *
 *
 *
 *
 *
 * */
