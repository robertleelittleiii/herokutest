/* 
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

// TODO:  Add ajax function to load pictures based on properties object.

function bindClickToProductItem () {
     $j('.product-item').click(function(){
      //   console.log(this);
         window.location.href = $j($j(this)).find("a.product-detail-link").attr('href');

      //   $j(this).find("a.product-detail-link").click();
     });
}


$j(document).ready(function(){
    
    bindClickToProductItem();
    
    // check for full screen and adjust layout
    if ($j("#full-screen").html().trim() == "true")
    {
        $j("div#page-middle-left").hide();
        $j("div#content").width("100%");
        $j('#Content').css('background',"white")

    }
    $j('#slides').slides({
        preload: true,
        preloadImage: '/images/interface/loading.gif',
        play: 5000,
        pause: 2500,
        slideSpeed: 600,
        efect: 'slide',
        hoverPause: true,
        next: 'next',
        prev: 'prev'


    });	
                   
    // resize the slider area and adjust the position of the prev next buttons.
    
    $j(".slides_container").width($j("#slider-width").html().strip());
    $j(".slides_container").height($j("#slider-height").html().strip());
    $j(".slides_container div").width($j("#slider-width").html().strip());
    $j(".slides_container div").height($j("#slider-height").html().strip());
    
    //  slideshow_width = $j("#slides").width();
    //  slideshow_height =$j("#slides").height();
    
    slideshow_width =  parseInt($j("#slider-width").html().strip());
    slideshow_height=  parseInt($j("#slider-height").html().strip());
    
    slideshow_offset = $j("#slides").offset();
    slideshow_middle = (slideshow_height / 2) - ($j("#slides .next").height() / 2);
  
    $j("#slides .next").offset({
        top: slideshow_middle + slideshow_offset.top, 
        left: slideshow_width + slideshow_offset.left
    });
        
    $j("#slides .prev").offset({
        top: slideshow_middle + slideshow_offset.top, 
        left: slideshow_offset.left - $j("#slides .prev").width()
    });


 
});

