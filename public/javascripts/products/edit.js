var productDetailsTable;
var vendorTable;

var product_detail_id="";
var product_detail_list_row="";



var toggleLoading = function() {
    $j("#loader_progress").toggle()
};
var toggleAddButton= function() {
    $j("#upload-form").toggle()
};



function wait(msecs)
{
    var start = new Date().getTime();
    var cur = start
    while(cur - start < msecs)
    {
        cur = new Date().getTime();
    }
}

function setUpPurrNotifier(headline, message)
{
    var notice = '<div class="notice">'
    + '<div class="notice-body">'
    + '<img src="/images/info.png" />'
    + '<h3>' + headline + '</h3>'
    + '<p>' + message + '</p>'
    + '</div>'
    + '<div class="notice-bottom">'
    + '</div>'
    + '</div>';

    $j( notice ).purr();
};

function buildproductDetailsListTable()
{
    productDetailsTable=$j('#product-detail-list-table').dataTable({
        "aLengthMenu": [[-1, 10, 25, 50], ["All", 10, 25, 50]],
        "fnDrawCallback": function() {
            $j(".best_in_place ").best_in_place();

        }
    });

}

$j.extend({
    getUrlVars: function(){
        var vars = [], hash;
        var hashes = window.location.href.slice(window.location.href.indexOf('?') + 1).split('&');
        for(var i = 0; i < hashes.length; i++)
        {
            hash = hashes[i].split('=');
            vars.push(hash[0]);
            vars[hash[0]] = hash[1];
        }
        return vars;
    },
    getUrlVar: function(name){
        return $j.getUrlVars()[name];
    }
});


function bindImageChage() {

    //
    //
    // image class bindings
    //

    $j('input#image').bind("change", function() {
        //alert("changed");
        toggleLoading();
        toggleAddButton();
        $j(this).closest("form").trigger("submit");
        $j(".imageSingle .best_in_place").best_in_place();

    });

}

function updateBestinplaceImageTitles() {
    $j(".imageSingle .best_in_place").best_in_place();

}

function refreshProductDetails() {
    var $product_id = $j("#product-id").text();
    $j("#loader_progress").hide();

    $j.post('/products/show_detail/' + $product_id, function(data)
    {
        $j('#product-detail-list').html(data);
        $j("#loader_progress").hide();
        buildproductDetailsListTable();
        $j(".details-row .best_in_place").best_in_place();

    });

}

function bindProductDetailNew ()
{
    $j('#new-product-detail-item').live('ajax:success', function(xhr, data, status){
        refreshProductDetails();

    }).live('ajax:beforeSend', function(e, xhr, settings){
        xhr.setRequestHeader('accept', '*/*;q=0.5, text/html, ' + settings.accepts.html);
        $j("#loader_progress").show();

    });

    $j('#duplicate-product_detail').live('ajax:success', function(xhr, data, status){
        refreshProductDetails();

    }).live('ajax:beforeSend', function(e, xhr, settings){
        xhr.setRequestHeader('accept', '*/*;q=0.5, text/html, ' + settings.accepts.html);
        $j("#loader_progress").show();

    });


    $j('#delete-product_detail').live('ajax:success', function(xhr, data, status){
        $j("#loader_progress").show();
        theTarget=this.parentNode.parentNode;
        var aPos = productDetailsTable.fnGetPosition( theTarget );
        productDetailsTable.fnDeleteRow(aPos) ;
        $j("#loader_progress").hide();
    });


};

function bindBlurToDepartmentPopup(){

    $j('#product_department_id').change(function() {

        var $product_id = $j("#product-id").text();
        // $j("#product_department_id").val()
        setTimeout(function(){

            $j.post('/products/render_category_div?id=' + $product_id, function(data)
            {
                $j('#category-div').html(data);
                $j("#loader_progress").hide();
            //bindBlurToDepartmentPopup();
            });
        }, 100);
    //alert('Handler for .blur() called.');
    });
    $j('.department-check').change(function() {

        var $product_id = $j("#product-id").text();
        // $j("#product_department_id").val()
        setTimeout(function(){

            $j.post('/products/render_category_div?id=' + $product_id, function(data)
            {
                $j('#category-div').html(data);
                $j("#loader_progress").hide();
            //bindBlurToDepartmentPopup();
            });
        }, 100);
    //alert('Handler for .blur() called.');
    });
}

function BestInPlaceCallBack(input) {
    if(input.data.indexOf("product_detail[color]") != -1)
    {
        //  alert("color changed");
        var $product_id = $j("#product-id").text();
        $j("#loader_progress").show();

        $j.post('/products/render_image_section/' + $product_id, function(data)
        {
            $j('.imagesection').html(data);
            $j("#loader_progress").hide();
            styleizefilebutton();
            bindImageChage();

        });
    }
} ;

$j(document).ready(function() {
    bindImageChage();
    bindProductDetailNew();
    buildproductDetailsListTable();
    bindBlurToDepartmentPopup();
});


function ajaxSave()
{
    
    tinyMCE.triggerSave();

    $j("#product_product_description_save").closest("form").trigger("submit");

}

