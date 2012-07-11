/* 
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

function bindCraigsListCheckClick() 
{
    $j('#craigs-list').click(function() {
     var csrf_token = $j('meta[name=csrf-token]').attr('content');
    var csrf_param = $j('meta[name=csrf-param]').attr('content');
    var rCraigslistVal = false;
    
    if( $j(this).attr('checked') == "checked")
        {
           var rCraigslistVal=true;
        }
    
    var request = $j.ajax({
        url: "/admin/update_prefs/",
        type: "POST",
        data: {
            site_prefs:{
                craigs_list: rCraigslistVal
            },
            authenticity_token : csrf_token
        }
    });


    request.done(function(msg) {
        //alert( msg );
        });

    request.fail(function(XHR, textStatus) {
        //the_XHR=XHR;
        //alert( "Request failed: " + textStatus );
        });
    
      
    });
    
};


function bindSiteToggleLinkClick() 
{
    $j('#site-button').click(function() {
        var buttonValue = $j("#site-button").html().strip()
        if (buttonValue == "Turn Site ON") {
            $j("#site-button").html("Turn Site OFF");
            $j("#site-status").html("Site is UP");
        }
        else {
            $j("#site-button").html("Turn Site ON");
            $j("#site-status").html("Site is DOWN (construction sign in place)");
        }
    });
    
};

$j(document).ready(function(){
    bindSiteToggleLinkClick();
    bindCraigsListCheckClick();
});