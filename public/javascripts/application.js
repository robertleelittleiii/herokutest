//
/// Size function
//
//

function sz(t) {
    a = t.value.split('\n');
    b=1;
    for (x=0;x < a.length; x++) {
        if (a[x].length >= t.cols) b+= Math.floor(a[x].length/t.cols);
    }
    b+= a.length;
    if (b > t.rows) t.rows = b;
}

//
// fix for IE Trim issue
//
//
 
if(typeof String.prototype.trim !== 'function') {
    String.prototype.trim = function() {
        return this.replace(/^\s+|\s+$/g, ''); 
    }
}

//
// fix for IE console.log() issue
//
//

if (typeof console == "undefined") {
    this.console = {
        log: function() {}
    };
}


//
//
//



$j(document).ready(function(){
    
    
      // check for full screen and adjust layout
    if ($j("#full-screen").length != 0) {
        
     if  ($j("#full-screen").html().trim() == "true")
    
    {
        $j("div#page-middle-left").hide();
        $j("div#content").width("100%");
        $j('#Content').css('background',"white")

    }
    }
    $j(".best_in_place").best_in_place();
    
    $j( ".datepicker" ).datepicker();

    $j('#page_body_tbl').css('height','450');

    if( $j('.main_tabnav').is(':hidden') )
    {
        $j('#content_body').css('height','627');
    }
    else
    {
        $j('#content_body').css('height','592');
    //$j('#content_body').height(465);

    }
     
    if ($j('#mainnav:visible').length != 0)
    {
        $j("div#page-middle-left").hide();
        $j("div#content").width("100%");
        $j('#Content').css('background',"white")

    }
     
     
    $j.fn.autoGrowInput = function(o) {

        o = $j.extend({
            maxWidth: 1000,
            minWidth: 0,
            comfortZone: 70
        }, o);

        this.filter('input:text').each(function(){

            var minWidth = o.minWidth || $(this).width(),
            val = '',
            input = $(this),
            testSubject = $('<tester/>').css({
                position: 'absolute',
                top: -9999,
                left: -9999,
                width: 'auto',
                fontSize: input.css('fontSize'),
                fontFamily: input.css('fontFamily'),
                fontWeight: input.css('fontWeight'),
                letterSpacing: input.css('letterSpacing'),
                whiteSpace: 'nowrap'
            }),
            check = function() {

                if (val === (val = input.val())) {
                    return;
                }

                // Enter new content into testSubject
                var escaped = val.replace(/&/g, '&amp;').replace(/\s/g,' ').replace(/</g, '&lt;').replace(/>/g, '&gt;');
                testSubject.html(escaped);

                // Calculate new width + whether to change
                var testerWidth = testSubject.width(),
                newWidth = (testerWidth + o.comfortZone) >= minWidth ? testerWidth + o.comfortZone : minWidth,
                currentWidth = input.width(),
                isValidWidthChange = (newWidth < currentWidth && newWidth >= minWidth)
                || (newWidth > minWidth && newWidth < o.maxWidth);

                // Animate width
                if (isValidWidthChange) {
                    input.width(newWidth);
                }

            };

            testSubject.insertAfter(input);

            $j(this).bind('keyup keydown blur update', check);

        });

        return this;

    };
     
}
)


