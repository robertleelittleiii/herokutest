/* 
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

// TODO:  Add ajax function to load pictures based on properties object.


function bindZoomClick() {
    $j("#zoom-invoice").click(function(){
        var zoomName= $j("#zoom-invoice").text() 
    
        if(zoomName == "Zoom Invoice") {
            $j("#zoom-invoice").text("Shrink Invoice")
            $j('#invoice-frame').effect('scale', {
                scale:'content',
                percent:250
            }, 1000, function(){
                $j("#invoice-tools").width("100%");

                
                
            });
        }
           
        else
        {
            $j("#zoom-invoice").text("Zoom Invoice")
            $j('#invoice-frame').effect('scale', {
                scale:'content',
                percent:40
            }, 1000, function() {
                $j("#invoice-tools").width("585px");

                
            });
        }   
            
    
    //  $j('#invoice-frame').effect('scale', {scale:'content',percent:40}, 1000);
       
        
    });   
}


$j(document).ready(function(){
    bindZoomClick();
    $j('#invoice-frame').effect('scale', {
        scale:'content',
        percent:40
    }, 1000);
    
});

