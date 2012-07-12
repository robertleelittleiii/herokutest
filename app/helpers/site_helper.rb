module SiteHelper
  #<div id="slides">
  #  <div class="slides_container">
  #    <div>
  #      <h1>Slide 1</h1>
  #      <p>Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.</p>
  #    </div>
  #    <div>
  #      <h1>Slide 2</h1>
  #      <p>Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.</p>
  #    </div>
  #    <div>
  #      <h1>Slide 3</h1>
  #      <p>Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.</p>
  #    </div>
  #    <div>
  #      <h1>Slide 4</h1>
  #      <p>Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.</p>
  #    </div>
  #  </div>
  #</div>
  #        
  
 def popup_page_link(page_name, the_class=nil, the_id=nil)
   @page = Page.where(:title=> page_name).first
   if @page .blank? then
     return "Page #{page_name} Not Found!!"
   end
    returnval = ""
    returnval = returnval + link_to(page_name, {:controller=>"site", :action=>:show_page, :id=>@page.id}, {:class=>the_class, :id=>the_id})
    return returnval.html_safe
 end
  
  def show_slider_gallary(page)
    if page.has_slider then
      returnval = ""
      returnval = returnval + "<div class=\"hidden-item\">"
      returnval =  returnval + "<div id='slider-width'> #{page.slider_width} </div>"
      returnval =  returnval + "<div id='slider-height'> #{page.slider_height} </div>"
      returnval =  returnval + "</div>"
      
      returnval = returnval + "<div id=\"slides\">"
      returnval =  returnval + "<div class=\"slides_container\" >"
      page.sliders.active.each do |slider| 
       
        returnval =  returnval + "<div>"
        
#        returnval =  returnval + "<h1>" + slider.slider_name + "</h1>"
        returnval = returnval + slide_edit_div(slider)
        returnval =  returnval + slider.slider_content 
        
        returnval =  returnval + "</div>"
      end
       returnval =  returnval + "</div>"

      
      returnval =  returnval +  "<a href=\"#\" class=\"prev\"><img src=\"/images/interface/arrow-prev.png\" width=\"24\" height=\"43\" alt=\"Arrow Prev\"></a>"

      returnval =  returnval + "<a href=\"#\" class=\"next\"><img src=\"/images/interface/arrow-next.png\" width=\"24\" height=\"43\" alt=\"Arrow Next\"></a>"

      returnval =  returnval + "</div>"
   
    
      return returnval.html_safe
    else
      return ""
    end rescue return ""
  end  


  def show_title_not_null(title, value, cell_params)
    returnval = ""
    returnval = returnval +'<td align="right" ><b>' + (value.blank? ? "" : title) + '</b></td>'
    returnval = returnval + '<td '+cell_params+'> ' + value + '</td>'
    return returnval.html_safe
  end
  
  def slide_edit_div(slide)
      returnval=""
    if session[:user_id] then
      user=User.find(session[:user_id])
      if user.roles.detect{|role|((role.name=="Admin") | (role.name=="Site Owner"))} then
        returnval="<div id=\"edit-slider\">"
        returnval=returnval+link_to(image_tag("interface/edit.png",:border=>"0", :class=>"imagebutton", :title => "Edit this Slider"),:controller => 'sliders', :id =>slide.id ,  :action => 'edit')
        returnval=returnval + "</div>"
      end
    end
    return returnval.html_safe
  end  
  
  def product_edit_div(product)
      returnval=""
    if session[:user_id] then
      user=User.find(session[:user_id])
      if user.roles.detect{|role|((role.name=="Admin") | (role.name=="Site Owner"))} then
        returnval="<div id=\"edit-product\">"
        returnval=returnval+link_to(image_tag("interface/edit.png",:border=>"0", :class=>"imagebutton", :title => "Edit this Product"),:controller => 'products', :id =>product.id ,  :action => 'edit')
        returnval=returnval + "</div>"

      end
    end
    return returnval.html_safe
  end

  def page_edit_div(page)
    returnval=""
    if session[:user_id] then
      user=User.find(session[:user_id])
      if user.roles.detect{|role|((role.name=="Admin") | (role.name=="Site Owner"))} then
        returnval="<div id=\"edit-pages\">"
        returnval=returnval+link_to(image_tag("interface/edit.png",:border=>"0", :class=>"imagebutton", :title => "Edit this Page"),:controller => 'pages', :id =>page.id ,  :action => 'edit')
        returnval=returnval + "</div>"
      end
    end
    return returnval.html_safe

  end
  
   
  def page_attr_display(page,full_screen="false")
    returnval=""
    returnval="<div id=\"attr-pages\" class=\"hidden-item\">"
    returnval=returnval+"<div id=\"full-screen\">"+(page.full_screen.to_s rescue full_screen)+"</div>"
    returnval=returnval + "</div>"
    return returnval.html_safe

  end
end
