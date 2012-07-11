/* 
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

// TODO:  Add ajax function to load pictures based on properties object.


var notice = ""

function setUpPurrNotifier(headline, message)
{
    var notice = '<div class="notice">'
    + '<div class="notice-body">'
    + '<img src="/images/interface/info.png" />'
    + '<h3>' + headline + '</h3>'
    + '<p>' + message + '</p>'
    + '</div>'
    + '<div class="notice-bottom">'
    + '</div>'
    + '</div>';
    if (message.length > 1) 
    {
            $j(notice).purr();
    }
    
    
}




$j(document).ready(function(){
    
    bindProductActions();
  bindChangeShipping() ; 
    // check for full screen and adjust layout
    if ($j("#full-screen").html().trim() == "true")
    {
        $j("div#page-middle-left").hide();
        $j("div#content").width("100%");
        $j('#Content').css('background',"white")

    }
   

 
});


function bindChangeShipping(){


    $j('#cart_shipping_type').change(function() {

        //alert("changed");
        //cart_item_id=$j(this).parent().parent().find("#cart-item-index").html().trim()
        //updateShoppingCartItemInfo($j(this).parent().parent().find(".shopping-cart-item-info"), cart_item_id)
        updateShoppingCartSummary();
        //updateShoppingCartView();
       // $j(this).parent().parent().find(".shopping-cart-item-info").html(
        
        
       // alert("add success");
        $j("#loader_progress").hide();


    });
    
}

function updateCartContents() {
            $j.ajax({
            url: "/site/get_cart_contents",
            dataType: "html",
            type: "GET",
            data: "" ,
            success: function (data)
            {
                //alert(data);
                if (data === undefined || data === null || data === "")
                {
                //display warning
                }
                else
                {
                   $j("#cart-contents").html(data);
                   
                }
            }
        });
    
}


function updateShoppingCartView() {
            $j.ajax({
            url: "/site/get_shopping_cart_info",
            dataType: "html",
            type: "GET",
            data: "" ,
            success: function (data)
            {
                //alert(data);
                if (data === undefined || data === null || data === "")
                {
                //display warning
                }
                else
                {
                   $j("#shopping-cart-info").html(data);
                }
            }
        });
    
}


function updateShoppingCartItemInfo(item_to_update, item_id) {
            $j.ajax({
            url: "/site/get_shopping_cart_item_info",
            dataType: "html",
            type: "GET",
            data: "item_no="+ item_id ,
            success: function (data)
            {
                //alert(data);
                if (data === undefined || data === null || data === "")
                {
                //display warning
                }
                else
                {
                   $j(item_to_update).html(data);
                }
            }
        });
    
}

function updateShoppingCartSummary() {
            $j.ajax({
            url: "/site/get_cart_summary_body",
            dataType: "html",
            type: "GET",
            data: "",
            success: function (data)
            {
                //alert(data);
                if (data === undefined || data === null || data === "")
                {
                //display warning
                }
                else
                {
                   $j(".cart-summary-body").html(data);
                }
            }
        });
    
}



function bindProductActions ()
{
    $j('.add-product').live('ajax:success', function(xhr, data, status){
        cart_item_id=$j(this).parent().parent().find("#cart-item-index").html().trim()
        updateShoppingCartItemInfo($j(this).parent().parent().find(".shopping-cart-item-info"), cart_item_id)
        updateShoppingCartSummary();
        updateShoppingCartView();
       // $j(this).parent().parent().find(".shopping-cart-item-info").html(
        setUpPurrNotifier("Inventory Warning",data)

        
       // alert("add success");
        $j("#loader_progress").hide();


    }).live('ajax:beforeSend', function(e, xhr, settings){
        xhr.setRequestHeader('accept', '*/*;q=0.5, text/html, ' + settings.accepts.html);
        $j("#loader_progress").show();

    });

    $j('.minus-product').live('ajax:success', function(xhr, data, status){
        cart_item_id=$j(this).parent().parent().find("#cart-item-index").html().trim()
        updateShoppingCartItemInfo($j(this).parent().parent().find(".shopping-cart-item-info"), cart_item_id)
        updateShoppingCartSummary();
        updateShoppingCartView();
       
       // alert("minus success");
                $j("#loader_progress").hide();


    }).live('ajax:beforeSend', function(e, xhr, settings){
        xhr.setRequestHeader('accept', '*/*;q=0.5, text/html, ' + settings.accepts.html);
        $j("#loader_progress").show();

    });


    $j('.remove-product').live('ajax:success', function(xhr, data, status){
        
        updateCartContents();
        bindProductActions();
        updateShoppingCartSummary();
        updateShoppingCartView();
        
        // alert("remove success");
        $j("#loader_progress").hide();
    }).live('ajax:beforeSend', function(e, xhr, settings){
        xhr.setRequestHeader('accept', '*/*;q=0.5, text/html, ' + settings.accepts.html);
        $j("#loader_progress").show();

    });


};
