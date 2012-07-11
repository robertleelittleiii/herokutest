var productTable;
   function bindClicktoProductTableRow(){
       $j('#product-table .product-row').on("click",function(){
        $j(this).addClass('row_selected');
        productID=$j(this).find("#product-id").text().strip();
        window.location = "/products/edit/"+productID;
    });}

$j(document).ready(function() {
    $j("#loader_progress").show();
    productTable=$j('#product-table-old').dataTable({
        "aLengthMenu": [[-1, 10, 25, 50], ["All", 10, 25, 50]]
    });
    
    $j("#loader_progress").show();
    
    productTableAjax=$j('#product-table').dataTable({
        "bProcessing": true,
        "bServerSide": true,
        "sAjaxSource": "/products/product_table",
        "fnRowCallback": function( nRow, aData, iDisplayIndex, iDisplayIndexFull ) {
            $j(nRow).addClass('product-row');
            $j(nRow).addClass('gradeA');
            
            return nRow;
        },
        
        "aoColumns": 
            [ 
                { "sWidth": "100" },
                { "sWidth": "300" },
                { "sWidth": "600" },
                null 
            ]
            ,
             "fnDrawCallback": function (){
                bindClicktoProductTableRow();
            }
    });
    
    $j("#product-table").css("width","100%")
    
    $j("#loader_progress").hide();



  
    $j('#delete-product-item').live('ajax:success', function(xhr, data, status){
        $j("#loader_progress").show();
        theTarget=this.parentNode.parentNode;
        var aPos = productTableAjax.fnGetPosition( theTarget );
        productTableAjax.fnDeleteRow(aPos) ;
        $j("#loader_progress").hide();
    });
});
