function bindThumbHover()
{
//   $j('.product-thumb').click(function(){
        
//   theTitle = $j(".product-picture").attr("title");
//   newContent = '<a href="'+$j(this).attr('src').replace('small_','') +'" class="product-picture" title="'+theTitle+'"><img src="'+ $j(this).attr('src').replace('small_','view_') +'"></a>';
//   $j("#product-main-image").html(newContent);
    
//  $j('.product-picture img').attr('src',$j(this).attr('src').replace('small_','view_'));
//  $j('.product-picture').attr("href",$j(this).attr('src').replace('small_',''));
      
//   $j(".zoomWrapperImage img").attr("src",$j(this).attr('src').replace('small_',''));
//   $j(".zoomPad img").attr("src",$j(this).attr('src').replace('small_','view_'));
    
//$j('a.product-picture').jqzoom({
//         zoomType: 'innerzoom'
//  });
//$j(".product-picture").attr("href");
//$j(".product-picture img").attr("src");
    
//$('#description').html($(this).attr('alt'));
//});
    
}
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

function bindSwatchClick() {
    $j(".product-swatch").click(function(){

        $j(".product-swatch").each(function(i,o){
            $j(o).removeClass("swatch-selected "); 
        });
        
        $j(this).addClass("swatch-selected ")
        $j("#product-selected-color").html($j($j(this).parent()).find("#color-name").html());
        var product_color = $j("#product-selected-color").html().trim();
        var product_id = $j("#product-id").html().trim();

        $j.ajax({
            url: "/site/get_sizes_for_color",
            dataType: "html",
            type: "GET",
            data: "id="+product_id+ "&color="+product_color ,
            success: function (data)
            {
                //alert(data);
                if (data === undefined || data === null || data === "")
                {
                //display warning
                }
                else
                {
                   $j("#product-size-items").html(data);
                   $j("#product-selected-size").html($j(".size-selected").html().strip());
                   bindSizeClick();
                }
            }
        });
        
    });
    
    
}

function bindSizeClick() {
    $j(".product-size-item").click(function(){
        $j(".product-size-item").each(function(i,o){
            $j(o).removeClass("size-selected "); 
        });
        
        $j(this).addClass("size-selected ")
        $j("#product-selected-size").html($j(this).html());

    });
    
    
}

function bindAddToCartClick() {
    $j("#add_to_cart").click(function(){
        var product_id = $j("#product-id").html().trim();
        var product_size = $j("#product-selected-size").html().trim();
        var product_color = $j("#product-selected-color").html().trim();
        var product_quantity  = $j("input#quantity").val();  
        $j.ajax({
            url: "/site/add_to_cart",
            dataType: "html",
            type: "Get",
            data: "id="+product_id+ "&color="+product_color + "&size=" + product_size +"&quantity="+product_quantity,
            success: function (data)
            {
                //alert(data);
                if (data === undefined || data === null || data === "")
                {
               
                 updateShoppingCartView(); 
                //display warning
                }
                else
                {
                      setUpPurrNotifier("Inventory Warning",data)
                      updateShoppingCartView(); 
   //alert("success");
                }
            }
        });
    });
   
}



function bindLiveActionOnQuantity () {
    $j("input#quantity").bind("keyup focusout",function(a,b){
        $j("#total-cost-dollars").html("$" + (parseFloat($j("input#quantity").val())*parseFloat($j("#product-price").html().trim().substr(1,100))).toFixed(2));
    });
  
  
//  #total-cost-dollars
   
}

$j(document).ready(function(){
    bindSwatchClick();
    bindSizeClick();
    bindLiveActionOnQuantity();
    bindAddToCartClick();  
    
    $j('a.product-picture').jqzoom({
        zoomType: 'innerzoom'
    });
//    bindThumbHover();
});
				
                                
                                
      
//       <a href="/uploads/picture/image/44/M106UWIR-BLW-1.jpg?1337001332" class="product-picture" title="Wired"><img alt="View_m106uwir-blw-1" src="/uploads/picture/image/44/view_M106UWIR-BLW-1.jpg?1337001332"></a>
  

