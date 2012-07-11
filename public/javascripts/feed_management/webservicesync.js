/* 
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
var $FilesToShow=1;

var toggleLoading = function() {
    $j("#loader_progress").toggle()
};
var toggleAddButton= function() {
    $j("#upload-form").toggle()
};

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
    setupNewImporter();

    setupFileButtonAction();
    
    setupDelete();
    
    updateSheetColumns();
    
    setupModelName();
    
    setupDeleteImportItem();
  
    setupMenuChange();
   
    setupNameChange();
   
    setUpRunImporterButton();
   
    $j("#set-up-importer-button").find("form").bind('ajax:before', function(){
        //         window.alert("before");
        // toggleLoading();
        }) 
    .bind('ajax:complete', function(){
        //          window.alert("after");

        //      toggleLoading();
        })
    .bind('ajax:success', function(event, data, status, xhr) {
        //$("#response").html(data);
        console.log(event);
        console.log(data);
        console.log(status);
        console.log(xhr);
        $j("#set-up-importer").html(data);
        setupMenuChange();

        $j("#importer-name").trigger("change");
    //  window.alert("success");
    });
    
    
    
    
});

function setUpRunImporterButton() {
    
    $j('#run-importer').bind("click", function() {
        $j("#importer-status-msg").html("Starting...");
        $j(this).everyTime(1000, 'importer', function() {
          
            loadImportProgress();
            if ($j("#importer-status-msg").text().strip() == "Process Complete")
            {
                $j(this).stopTime('importer');
                
            //$j("#import-progress-block").html("");

            //   alert("DONE!!!");

            }
        });
    //  alert("clicked");
    });  
}

function BestInPlaceCallBack(input) {

    if (input.data.indexOf("importer[name]") != -1)
    {  
        importer_id=$j("#importer-id").text().strip();

        $j.ajax({
            url: "/feed_management/set_up_importer_partial",
            dataType: "html",
            type: "POST",
            data: "id="+importer_id+ "&importer_type=web-service" ,
            success: function (data)
            {
                //alert(data);
                if (data === undefined || data === null || data === "")
                {
                //display warning
                }
                else
                {
                    $j("#set-up-importer").html(data);
                    setupMenuChange(); 

                }
            }
        });
    
    
    };
    

    
    
} ;
 

function setupNameChange() {
    
     
    $j("div#best_in_place_importer_name").bind('ajax:before', function(){
        window.alert("before");
    // toggleLoading();
    }) 
    .bind('ajax:complete', function(){
        window.alert("after");

    //      toggleLoading();
    })
    .bind('ajax:success', function(event, data, status, xhr) {
        //$("#response").html(data);
        console.log(event);
        console.log(data);
        console.log(status);
        console.log(xhr);
        // $j("#set-up-importer").html(data);
        // setupMenuChange();

        //// $j("#importer-name").trigger("change");
        window.alert("success");
    });
     
    
    
}



function setupMenuChange() {
    
    $j('#importer-name').bind("change", function() {
        selected_item= $j("#importer-name option:selected");
        $j.ajax({
            url: "/feed_management/importer_name_partial",
            dataType: "html",
            type: "POST",
            data: "id="+selected_item.val()+ "&importer_name="+selected_item.text() ,
            success: function (data)
            {
                //alert(data);
                if (data === undefined || data === null || data === "")
                {
                //display warning
                }
                else
                {
                    $j("#importer-id").html(selected_item.val());
                    $j("#importer-name-div").html(data);
                    $j("#best_in_place_importer_name.best_in_place").best_in_place();
                }
            }
        });
        
        updateWebServiceInfo();

        $j.ajax({
            url: "/feed_management/import_action_partial",
            dataType: "html",
            type: "POST",
            data: "id="+selected_item.val()+ "&importer_name="+selected_item.text() ,
            success: function (data)
            {
                //alert(data);
                if (data === undefined || data === null || data === "")
                {
                //display warning
                }
                else
                {
                    $j('div#import-action-div').block({ 
                        message: '<h2><img src="/images/busy.gif" /> Just a moment...</h2>', 
                        css: {
                            border: '3px solid #a00',
                            width: '300px'
                        } 
                    }); 
                    
                    $j("#import-action").html(data);
                    initStylizeInput();
                    setupFileButtonAction();
                    setupModelName();
                    setupMapToButton();
                    setupNameChange();
                    updateModelName();
                    updateSheetColumns();
                    $j("#importer-item-list").find(".best_in_place").best_in_place();
                    setupDeleteImportItem();
                    $j("#importer-status-msg").html("");
                    setUpRunImporterButton();
                   // $j('div#import-action-div').unblock(); 

                // $j(".best_in_place").best_in_place();

                }
            }
        });
        
    });
    
    
}

function setupProgressBar(percent_complete) {
    $j("#importer-status-img").progressbar({
        value: Number(percent_complete)
    });
}

function loadImportProgress() {
    importer_id=$j("#importer-id").text().strip();

    $j.ajax({
        url: "/feed_management/load_importer_progress",
        dataType: "html",
        type: "POST",
        data: "id="+importer_id,
        success: function (data)
        {
            //alert(data);
            if (data === undefined || data === null || data === "")
            {
            //display warning
            }
            else
            {
                $j("#import-progress-block").html(data);
                progress_done=$j("#progress-done").text().strip();

                setupProgressBar(progress_done);

            }
        }
    });
}

function setupNewImporter() {
    
    $j('#new-importer').bind("click", function() {
        //    $j("#importer-name").trigger("change");
        //    alert("clicked");
        });
    
}

function setupMapToButton() {
    
    $j('#map-to-button').bind("click", function() {
        importer_id=$j("#importer-id").text().strip();
        from_selected_item= $j("#from-select option:selected");
        to_selected_item= $j("#to-select option:selected");
        to_table_name= $j("#importer_table_name option:selected")
        from_table_name= $j("#table-name").text().strip();

        $j.ajax({
            url: "/feed_management/add_importer_item",
            dataType: "html",
            type: "POST",
            data: "id="+importer_id + "&from_table_name=" + from_table_name + "&from_column="+from_selected_item.val()+ "&to_column="+to_selected_item.val()+"&from_column_name="+encodeURIComponent(from_selected_item.text())+"&to_column_name="+encodeURIComponent(to_selected_item.text())+"&to_table_name="+encodeURIComponent(to_table_name.text()),
            success: function (data)
            {
                //alert(data);
                if (data === undefined || data === null || data === "")
                {
                //display warning
                }
                else
                {
                    $j("#importer-item-list").html(data);

                    setupDeleteImportItem();

                }
            }
        });
    //      alert("clicked");
    });
    
}

function setupModelName() {
    
    $j('#importer_table_name').bind("change", function() {
        updateModelName();
    });
    
}

function updateWebServiceInfo() {
        selected_item= $j("#importer-name option:selected");

        $j.ajax({
            url: "/feed_management/web_service_info_partial",
            dataType: "html",
            type: "POST",
            data: "id="+selected_item.val()+ "&importer_name="+selected_item.text() ,
            success: function (data)
            {
                //alert(data);
                if (data === undefined || data === null || data === "")
                {
                //display warning
                }
                else
                {
                    $j("#web-service-info-div").html(data);
                    $j("#best_in_place_importer_login_id.best_in_place").best_in_place();
                    $j("#best_in_place_importer_password.best_in_place").best_in_place();
                    $j("#best_in_place_importer_full_uri_path.best_in_place").best_in_place();

                }
            }
        });
        
}

function updateModelName(){
    selected_item= $j("#importer_table_name option:selected");
    $j.ajax({
        url: "/feed_management/columns_render_partial",
        dataType: "html",
        type: "POST",
        data: "id="+selected_item.val()+ "&model_name="+selected_item.text() ,
        success: function (data)
        {
            //alert(data);
            if (data === undefined || data === null || data === "")
            {
            //display warning
            }
            else
            {
                $j("#table-columns").html(data);

            }
        }
    });
}

function setupFileButtonAction()
{
    
    $j('input#file').bind("change", function() {
        toggleLoading();
        toggleAddButton();
        $j(this).closest("form").trigger("submit");
    });
}
function setupDelete() 
{
    $j('.delete_file').bind('ajax:success', function(event, data, status, xhr) {
        //$("#response").html(data);
        $j(this).closest(".fileSingle").fadeOut();
        $j(this).closest(".fileSingle").remove();

        $fileCount = $j('.fileSingle').length
        if ($fileCount < $FilesToShow)
        {
            $j('#filebutton').show();
            updateSheetColumns();
        }
      
    });
}
 
function setupDeleteImportItem() 
{
    $j('.delete_import_item').bind('ajax:success', function(event, data, status, xhr) {
        //$("#response").html(data);
        $j(this).closest(".importer-item").fadeOut();
        $j(this).closest(".importer-item").remove();
    });
}

 
 
function updateSheetColumns()
{
    fullfilepath=$j("#full-file-path");

    $j.ajax({
        url: "/feed_management/xsd_columns_render_partial",
        dataType: "html",
        type: "POST",
        data: "file_path="+fullfilepath.text().strip() ,
        success: function (data)
        {
            //alert(data);
            if (data === undefined || data === null || data === "")
            {
            //display warning
            }
            else
            {
                $j("#sheet-columns").html(data);
                $j('div#import-action-div').unblock(); 


            }
        }
    });
     
}