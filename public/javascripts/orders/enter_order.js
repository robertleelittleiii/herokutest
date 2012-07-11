/* 
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */


function bindCopyAddressClick() {
    $j("#copy-to-billing").click(function(){
        $j("#order_bill_first_name").val($j("#order_ship_first_name").val());
        $j("#order_bill_last_name").val($j("#order_ship_last_name").val());
        $j("#order_bill_street_1").val($j("#order_ship_street_1").val());
        $j("#order_bill_street_2").val($j("#order_ship_street_2").val());
        $j("#order_bill_city").val($j("#order_ship_city").val());
        $j("#order_bill_state").val($j("#order_ship_state").val());
        $j("#order_bill_zip").val($j("#order_ship_zip").val());
    });   
}


$j(document).ready(function(){
    bindCopyAddressClick();
   
});