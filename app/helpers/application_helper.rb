module ApplicationHelper

  
    def find_cart
      
    @cart=Cart.get_cart("cart"+session[:session_id])
    
#   @cart = Cart.get_cart(session[:cart])
#   session[:cart] = @cart.id
  
    end

  def display_html(data)
    data.html_safe
  end

  def create_menu_list (menu_name, with_id=true)
   
    returnList=[]

    @menu = Menu.find_by_name(menu_name)

    if @menu.blank?  then
      returnList = ["Can't Find '"+ menu_name + "'"]
    else
    
      @menus = Menu.find_menu(@menu.id)
      if with_id then
        returnList = @menus.collect{|x| [x.name,x.id]}
      else
        returnList = @menus.collect{|x| x.name}
      end
      return returnList
    end
  end
  
  def create_menu_lowest_child_list(menu_name, menu_id=nil,with_id=true)
    if menu_id.blank? then
      if menu_name.blank? then
        return []
      else
        @start_menu = Menu.find_by_name(menu_name)
        if @start_menu.blank? then
          return "no menu found"
        end
      end
    else
      @start_menu = Menu.find(menu_id)
    end
      
    @menus = Menu.find_menu(@start_menu.id)
      
    return_list = []
    @menus.each do |menu|
      if menu.menus.size == 0 then
        if with_id then
          return_list = return_list + [[menu.name, menu.id]]
        else
          return_list = return_list + [menu.name]
        end
      else
        return_list= return_list + create_menu_lowest_child_list("",menu.id,with_id)
      end
    end
    return return_list
  end
    
    
    
    
  
  
  def popup_link(link, name, window_name)
    return link_to name, link, :id=>window_name,:class=>"open-remote-url" rescue ""
  end
  
  def get_page_title
    if @page.blank? then
      return ""
    else
      return  @page.title rescue "Page Title not Found"
    end
  end

  def editabletextareacreate (field_name, field_pointer)
    '<div id="field_'+field_name+'" class="myaccountcontentitem">' +
      editabletextarea(field_name,field_pointer)+
      '</div>'
  end

  def editabletextarea (field_name, field_pointer)
    css_class= 'class="blocklist"'
    field_value=field_pointer[field_name]

    link_to(image_tag("interface/edit.png",:border=>"0", :class=>"imagebutton"),
      :url => {
        :action => "edit_ajax_textarea",
        :id => field_pointer.id,
        :field => field_name,
        :pointer_class=>field_pointer.class },
      :update => "field_"+field_name, :remote=>:true) +
      '<div '+css_class+'>'+h(field_value)+
      '</div>'
  end

  def editabletextareaedit (field_name, field_pointer)
    return_field=text_area_tag(field_name, field_pointer[field_name], :cols=>"80", :rows=>"20", :onkeyup=>'sz(this);',:class => "mceEditor" )

    #:cols=>"80", :rows=>"20",

    form_remote_tag(:update => 'field_' + field_name,  :url => { :action => 'update_ajax', :method => :post,  :id => field_pointer.id,:pointer_class=>field_pointer.class,  :field => field_name}, :before => "tinyMCE.triggerSave(true,true);"  )do
      return_field+ submit_tag("Save", :class=>"input_button") +
        button_to_remote("Cancel", {:url => { :action => "cancel_ajax", :id => field_pointer.id,  :field => field_name,:pointer_class=>field_pointer.class }, :update => 'field_' + field_name}, :class=>"input_button")+ "<br>"
    end

  end

  def editablefieldcreate(field_name,field_pointer, opts = {})

    #logger.info ("opts")
    #logger.info(opts[:class])
  
    if field_pointer[field_name].class == String and field_pointer[field_name].length > 85 then
      ('<div id="field_'+field_name.to_s+'" class="myaccountcontentitem">' +
          best_in_place(field_pointer, field_name, :type => :textarea, :nil => "Click me to add content!", :class => opts[:class],:sanitize=>opts[:sanitize]).html_safe +
          '</div>').html_safe
    else
          
      ('<div id="field_'+field_name.to_s+'" class="myaccountcontentitem">' +
          best_in_place(field_pointer, field_name, :type => :input, :nil => "Click me to add content!", :class=>opts[:class], :sanitize=>opts[:sanitize]).html_safe +
          '</div>').html_safe
    end
  end 

  def editablefieldcreate2(field_name,field_pointer)

    ('<div id="field_'+field_name.to_s+'" class="myaccountcontentitem">' +
        editablefield(field_name,field_pointer)+
        '</div>').html_safe

  end

  def best_in_place(object, field, opts = {})
    #logger.info ("best_in_place")
    for item in opts do
      # logger.info(item)
    end
    #logger.info(opts)
    #logger.info(opts[:class])
    #logger.info(opts[:sanitize])
    
    opts[:type] ||= :input
    opts[:collection] ||= []

    field = field.to_s
    value = object.send(field).blank? ? "" : object.send(field) rescue object[field]
    collection = nil
    if opts[:type] == :select && !opts[:collection].blank?
      v = object.send(field)
      #logger.info(v)
      #logger.info (opts[:collection])
      value = Hash[opts[:collection]][!!(v =~ /^[0-9]+$/) ? v.to_i : v] || "Please Select..."
      collection = opts[:collection].to_json
    end
    if opts[:type] == :checkbox
      fieldValue = !!object.send(field)
      if opts[:collection].blank? || opts[:collection].size != 2
        opts[:collection] = ["No", "Yes"]
      end
      value = fieldValue ? opts[:collection][1] : opts[:collection][0]
      collection = opts[:collection].to_json
    end
    extraclass = "'"
    puts("opts[:class] #{opts[:class]}")
    if !opts[:class].blank? 
      extraclass = opts[:class] + "'"
    end
      
    #fix for rails settings gem
    object_class_name = object.class.to_s.gsub("::", "_").underscore
    object_class_name = (object_class_name == "active_support_hash_with_indifferent_access" ? "settings" : object_class_name)
    
    
    
    out = "<div class='best_in_place " + extraclass
    out << " id='best_in_place_#{object_class_name}_#{field}'"
    out << " data-url='#{opts[:path].blank? ? url_for(object).to_s : url_for(opts[:path])}'"
    out << " data-object='#{object_class_name}'"
    out << " data-collection='#{collection}'" unless collection.blank?
    out << " data-attribute='#{field}'"
    out << " data-activator='#{opts[:activator]}'" unless opts[:activator].blank?
    out << " data-nil='#{opts[:nil].to_s}'" unless opts[:nil].blank?
    out << " data-type='#{opts[:type].to_s}'"
    if !opts[:sanitize].nil? && !opts[:sanitize]
      out << " data-sanitize='false'>"
      out << sanitize(value.to_s, :tags => %w(b i u s a strong em p h1 h2 h3 h4 h5 ul li ol hr pre span img), :attributes => %w(id class))
    else
      out << ">#{sanitize(value.to_s, :tags => nil, :attributes => nil)}"
    end
    out << "</div>"
    return out
  end


  def editablefield(field_name,field_pointer)

    if field_name=="password"
      field_value="***********"
    else
      field_value=field_pointer[field_name]
    end
    if field_value.to_s.empty?
      field_value="(empty)"
    end
  
    if field_pointer[field_name].class == String and field_pointer[field_name].length > 85 then
      css_class= 'class="blocklist"'
    else
      css_class='class="blocklist2"'
    end

    (link_to(image_tag("interface/edit.png",:border=>"0", :class=>"imagebutton"),
        {
          :action => "edit_ajax",
          :id => field_pointer.id,
          :field => field_name,
          :pointer_class=>field_pointer.class }, :remote=>true,
        :update => "field_"+field_name) +
        ('<div '+css_class+'>'+h(field_value)+
          '</div>').html_safe)

  end

  def editablefieldedit (field_name, field_pointer)
    if field_name=="password" then
      return_field=password_field_tag(field_name, field_pointer[field_name],  :class => 'input_text_field', :size=>'20', :onkeyup=>'sz(this);' ) + password_field_tag(field_name+"_check", field_pointer[field_name+"_check"],  :class => 'input_text_field', :size=>'20', :onkeyup=>'sz(this);' )
    else
      if field_pointer[field_name].class == String and field_pointer[field_name].length > 85 then
        return_field=text_area_tag(field_name, field_pointer[field_name],  :class => 'input_text_area', :onkeyup=>'sz(this);' )
      else
        if field_pointer[field_name].class == String then
          field_size=field_pointer[field_name].length
        else
          field_size=field_pointer[field_name].to_s.length
        end
        return_field=text_field_tag(field_name, field_pointer[field_name],  :class => 'input_text_field', :size=>field_size , :onkeyup=>'sz(this);' )
      end
    end
    return_value = form_tag( {:action => 'update_ajax', :method => :post,  :id => field_pointer.id,:pointer_class=>field_pointer.class,  :field => field_name}, { :remote=>true }) do
      return_field + submit_tag("Save", :class=>"input_button")
    end
    return_value = return_value+ button_to("Cancel", { :action => "cancel_ajax", :id => field_pointer.id,  :field => field_name,:pointer_class=>field_pointer.class },{ :remote=>true, :update => 'field_' + field_name, :class=>"input_button"})+ "<br>".html_safe
  
    return return_value
  end

  def editablecheckboxedit (field_name, field_pointer,field_title)
  
    check_box_tag( "#{field_name}", field_pointer.id, field_pointer[field_name], {
        :onchange => "#{remote_function(:url  => {:action => "update_checkbox", :id=>field_pointer.id, :field=>field_name ,:pointer_class=>field_pointer.class},
        :with => "'current_status='+checked")}"})+field_title

  end
  def ajax_select(field_name, field_object, field_pointer, value_list)
    ('<div id="field_'+field_name.to_s+'" class="myaccountcontentitem">' +
        best_in_place(field_pointer, field_name, :type => :select, :collection => value_list) +
        '</div>').html_safe
    #  <%= best_in_place @user, :country, :type => :select, :collection => @countries %>

  end

  def ajax_select2(field_name, field_object, field_pointer, value_list, prompt='Please Select...')
    
    select(field_object,"#{field_name}", value_list,{ :prompt => prompt}, {"data-id"=>field_pointer.id,
        :onchange => "#{remote_function(:url  => {:action => "update_ajax", :id=>field_pointer.id, :field=>field_name, :pointer_class=>field_pointer.class},
        :with => "'#{field_name}='+value")}"}
    )

  end

  #def ajax_select(field_name, field_object, field_pointer, value_list)
  #         select(field_object,"#{field_name}", value_list,{ :prompt => 'Please Select...'}, {"data-id"=>field_pointer.id,
  #                  :onchange => "#{remote_function(:url  => {:action => "update_ajax", :id=>field_pointer.id, :field=>field_name, :pointer_class=>field_pointer.class},
  #                                                      :with => "'#{field_name}='+value")}#"}
  #                                                  )
  #
  #end

  def editablecheckboxeditwdisable (field_name, field_pointer,field_title, is_disabled)
    if (not is_disabled)
      spanText="<span class='disabled-text'>"+field_title+"</span>"
    else
      spanText=field_title
    end
    check_box_tag( "#{field_name}]", field_pointer.id, field_pointer[field_name], {:disabled=>(not is_disabled),
        :onchange => "#{remote_function(:url  => {:action => "update_checkbox", :id=>field_pointer.id, :field=>field_name},
        :with => "'current_status='+checked")}"})+spanText

  end



  def  ajax_calendar_date_select(field_name, field_pointer)
    calendar_date_select_tag(field_name,field_pointer[field_name],
      {:onchange => "#{remote_function(:url  => {:action => "update_ajax",:pointer_class=>field_pointer.class, :id=>field_pointer.id, :field=>field_name},
        :with => "'#{field_name}='+$F(this)")}",  :year_range => [1901, 2020]})



  end

  def editablecheckboxtag  (field_name, field_pointer,field_title, tag_list_name,html_options={} )
    tag_name="#{tag_list_name.singularize}_list"
    tag_array= field_pointer.send(tag_name)
    tag_array= tag_array.collect { |item| item.downcase.strip  }
    field_name_d = field_name.downcase.strip
    is_checked = tag_array.include?(field_name_d)

    check_box_tag("#{field_name}]", field_pointer.id, is_checked, html_options.merge({
        :onchange => "#{remote_function(:url  => {:action => "update_checkbox_tag", :id=>field_pointer.id, :field=>field_name, :tag_name=>tag_name},
        :with => "'current_status='+checked")}"}))+field_title
  end

  def hidden_div_if(condition, attributes = {})
    if condition
      attributes["style"] = "display: none"
    end
    attrs = tag_options(attributes.stringify_keys)
    "<div #{attrs}>".html_safe
  end


  def controller_stylesheet_link_tag
    stylesheet = "#{params[:controller]}.css"

    if File.exists?(File.join(Rails.public_path, 'stylesheets', stylesheet))
      stylesheet_link_tag stylesheet
    end
  end

  def controller_javascript_include_tag
    javascript = "#{params[:controller]}/#{params[:action]}.js"

    if File.exists?(File.join(Rails.public_path, 'javascripts', javascript))
      javascript_include_tag javascript
    end
  end

  def tab_link_to(*args, &block)
    if block_given?
      options      = args.first || {}
      html_options = args.second
      concat(link_to(capture(&block), options, html_options))
    else
      name         = args.first
      options      = args.second || {}
      html_options = args.third
    end

    the_controller_name = options[:controller]
    the_action_name = options[:action]


    if session[:user_id] then
      user =  User.find_by_id(session[:user_id])

      if user.roles.detect{|role|
          role.rights.detect{|right|
            ((right.action == the_action_name)|(right.action == "*")|(right.action.include? the_action_name)) && right.controller == the_controller_name
          }
        }

        add_tab do |t|
          t.named name
          t.titled the_controller_name
          t.links_to :controller => the_controller_name, :action =>  the_action_name
        end
        #return_value = the_tab.create(the_controller_name, name) do
        # render :controller => the_controller_name, :action =>  the_action_name
        #  link_to(*args,&block)
        #end
        return
      else
        return ""
      end

      #  url = url_for(options)

      #  if html_options
      #    html_options = html_options.stringify_keys
      #    href = html_options['href']
      #    convert_options_to_javascript!(html_options, url)
      #    tag_options = tag_options(html_options)
      #  else
      #    tag_options = nil
      #  end

      #  href_attr = "href=\"#{url}\"" unless href
      #  "<a #{href_attr}#{tag_options}>#{name || url}</a>"
      # end

    end
  end





  def app_link_to(*args, &block)
    if block_given?
      options      = args.first || {}
      html_options = args.second
      concat(link_to(capture(&block), options, html_options))
    else
      name         = args.first
      options      = args.second || {}
      html_options = args.third
    end

    the_controller_name = options[:controller]
    the_action_name = options[:action]
    #puts("#{the_action_name}")
    user =  User.find_by_id(session[:user_id])

    if user.roles.detect{|role|
        role.rights.detect{|right|
          ((right.action == the_action_name)|(right.action == "*")) && right.controller == the_controller_name
        }
      }
      return link_to(*args,&block)
    else
      return ""
    end

    #  url = url_for(options)

    #  if html_options
    #    html_options = html_options.stringify_keys
    #    href = html_options['href']
    #    convert_options_to_javascript!(html_options, url)
    #    tag_options = tag_options(html_options)
    #  else
    #    tag_options = nil
    #  end

    #  href_attr = "href=\"#{url}\"" unless href
    #  "<a #{href_attr}#{tag_options}>#{name || url}</a>"
    # end

  end


  def   buildmenuitem(menuItem, html_options, span_options, class_options=nil)
    #    html_options = Menu.create_hash_from_string(menuItem.html_options)
    # html_options = {}
    return_link = ""
    class_options==nil ? class_options={} : ""
    case menuItem.m_type
    when "1"
      menuText="<span "+ span_options +">"+menuItem.name.titlecase + "</span>"
      if (menuItem.page_id.blank?)

      else      
        class_options.merge!({:action => "show_page", :controller =>"site", :id=>menuItem.page_id})
      end
      if(menuItem.has_image and not menuItem.pictures.empty?) then
        item_link_to = image_tag(menuItem.pictures[0].image_url.to_s, :border=>"0", :alt=>menuItem.name.titlecase.html_safe)
      else
        item_link_to = menuText.html_safe
      end
      return_link =  link_to(item_link_to, class_options, html_options)
        
    when "2"
      return_link = menuItem.rawhtml
    when "3"
      menuText="<span "+ span_options +">"+menuItem.name.titlecase + "</span>"

      if(menuItem.has_image) then
        menuText = image_tag(menuItem.pictures[0].image_url.to_s, :border=>"0", :alt=>menuItem.name.titlecase.html_safe)
      else
        menuText="<span "+ span_options +">"+menuItem.name.titlecase + "</span>"
      end
      return_link = link_to(menuText.html_safe, {},{:class=>'menu-title'})
    when "4"
      menuText="<span "+ span_options +">"+menuItem.name.titlecase + "</span>"
      class_options = menuItem.rawhtml
      
      if(menuItem.has_image and not menuItem.pictures.empty?) then
        item_link_to = image_tag(menuItem.pictures[0].image_url.to_s, :border=>"0", :alt=>menuItem.name.titlecase.html_safe)
      else
        item_link_to = menuText.html_safe
      end
      return_link =  link_to(item_link_to, class_options, html_options)

      #    return_link =  link_to(item_link_to, class_options, html_options.merge!(:target=>"_blank"))
      
    when "5"
      
      menuText="<span "+ span_options +">"+menuItem.name.titlecase + "</span>"
      top_menu = Menu.find(session[:parent_menu_id]) rescue {}
      case menuItem.rawhtml
      when "1"
        if(menuItem.has_image and not menuItem.pictures.empty?) then
          item_link_to = image_tag(menuItem.pictures[0].image_url.to_s, :border=>"0", :alt=>menuItem.name.titlecase.html_safe)
        else
          item_link_to = menuText.html_safe
        end
        
        return_link =  link_to(item_link_to, {:controller=>:site, :action=>:show_products, :department_id=>top_menu.name, :category_id=>menuItem.name}, html_options)
      when "2"
        if(menuItem.has_image and not menuItem.pictures.empty?) then
          item_link_to = image_tag(menuItem.pictures[0].image_url.to_s, :border=>"0", :alt=>menuItem.name.titlecase.html_safe)
        else
          item_link_to = menuText.html_safe
        end
        
        return_link =  link_to(item_link_to, {:controller=>:site, :action=>:show_products, :department_id=>top_menu.name, :category_id=>menuItem.name, :category_children=>true}, html_options)

      end 
      
     

      
      
      
      
      
      
      
      
      
      
      
      #  internal call to controller and action
      #                    class_options = { :action => menuItem.action, :controller =>menuItem.controller}.merge(Menu.create_hash_from_string(menuItem.class_options))
      #                    item_link_to = menuItem.name.upcase
      #                    return_link =  link_to(item_link_to, class_options, html_options)
      #                when 3
      #                    class_options = menuItem.url
      #                    item_link_to = menuItem.name
      #                    return_link =  link_to(item_link_to, class_options, html_options)
      #                 when 4
      #                    class_options = menuItem.url
      #                    item_link_to = image_tag(menuItem.picture)
      #                    return_link =  link_to(item_link_to, class_options, html_options)
      #                when 5
      #                   return_link = menuItem.raw_html
    end     
    
    #puts(return_link)       

    
    return return_link.html_safe rescue "<none>"
  end
  
  def buildverticlesubmenu(params=nil)
   
    @menu_id= session[:parent_menu_id] || 0
    #puts("in build sub menu with:", session[:parent_menu_id] )
    
    return "" if @menu_id==0
    
    @menus = Menu.find(@menu_id) rescue (return(""))

    @prehtml = params[:prehtml] || ""
    @posthtml = params[:posthtml] || ""
   
    @article_name = params[:article_name] || ""
    
    html_options = {}
    
    html_options.merge!({:class=>params[:class]}) 

    returnMenu=""
   
    for @menu in @menus.menus
      
      if @menu.name== @article_name
        returnMenu = returnMenu + params[:selected_class] + "<div class='menu-selected'>" + @menu.name + "</div>" + @posthtml
      else
        returnMenu=  returnMenu + @prehtml + self.buildmenuitem(@menu,html_options,"") + @posthtml

      end
      
      if @menu.menus.count > 0 then
        returnMenu = returnMenu + buildsubmenus(@menu.menus, 0)
      end
      
    end
      
    return returnMenu.html_safe
    
  end
   
 
  def buildverticalmenu(params=nil)
    @menu_id= params[:menu_id]
    @prehtml = params[:prehtml]
    @posthtml = params[:posthtml]
    @current_page = params[:current_menu]
    
    @menu = Menu.find_by_name(@menu_id)
    html_options = {}
    
    html_options.merge!({:class=>params[:class]}) 
    
    returnMenu=""


    if @menu.blank? then
      returnMenu = "Can't Find '"+ @menu_id + "'"
    else
      @menus = Menu.find_menu(@menu.id)

      for @menu in @menus
        # html_options = (@menu.name==@current_page ? html_options.merge!({:class=>"menu-selected"}) : html_options )
        if @menu.name==@current_page
          returnMenu = returnMenu + @prehtml + "<div class='menu-selected'>" + @menu.name + "</div>" + @posthtml 
        else
          returnMenu=  returnMenu + @prehtml + self.buildmenuitem(@menu,html_options,"") + @posthtml
        end
       
        if @menu.menus.count > 0 then
          returnMenu = returnMenu + buildsubmenus(@menu.menus, 0)
        end
        
      end
    end
    return returnMenu.html_safe
  end

  def buildhorizontalmenu(params=nil)
    html_options = {}
    
    html_options.merge!({:class=>params[:class]}) 
    
    input_params = {}
    
    input_params.merge!({:top_menu=>true})
    
    @prehtml = params[:prehtml] || ""
    @posthtml = params[:posthtml] || ""
    @menu_id= params[:menu_id]

    @page_name = params[:current_page] || ""
    
    if not @page_name.blank? then
      
      @current_sub_menu = Menu.find_by_name(@page_name)
      @parent_name = @current_sub_menu.blank? ? "" : @current_sub_menu.menu.name
      
    end
    
    returnMenu=""

    @menu = Menu.find_by_name(@menu_id)

    if @menu.blank?  then
      returnMenu = "Can't Find '"+ @menu_id + "'"
    else
    
      @menus = Menu.find_menu(@menu.id)
      
      breaker_val = params[:breaker] || " | "
      breaker = ""
      for @menu in @menus 
        #puts("menu vs page name",@menu.name, params[:current_page])
        if @menu.name == params[:current_page]
          returnMenu=  returnMenu + breaker + params[:selected_class] + self.buildmenuitem(@menu,html_options,"",input_params) + @posthtml
        else 
          if @menu.name == @parent_name then
            returnMenu=  returnMenu + breaker + params[:selected_class] + self.buildmenuitem(@menu,html_options,"",input_params) + @posthtml
          else
            returnMenu=  returnMenu + breaker + @prehtml+ self.buildmenuitem(@menu,html_options,"",input_params) + @posthtml
          end
        end
        breaker = breaker_val
      end
    end
        
    return returnMenu.html_safe
  end

  def buildhorizontalmenuprodrop(params=nil)
    @menu_id= params[:menu_id]
    returnMenu=""

    @menu = Menu.find_by_name(@menu_id)

    if @menu.blank?  then
      returnMenu = "Can't Find '"+ @menu_id + "'"
    else
      @menus = Menu.find_menu(@menu.id)
      
      breaker = ''
      breaker_val = params[:breaker] || ""

      
      for @menu in @menus
        if @menus.last == @menu then
          html_link_class="top_link last_link"
        else
          html_link_class="top_link"
        end
        puts("current page:#{params[:current_page]}, Menu Name:#{@menu.name} ")
        if @menu.name == params[:current_page]
          html_link_class = html_link_class +" "+ params[:selected_class]
        end

        if @menu.menus.count>0 then
          subMenus=self.buildsubmenus(@menu.menus,0)
          returnMenu=  returnMenu + breaker + "<li class='top'>"+ self.buildmenuitem(@menu, {:class=>html_link_class}, "class='down'") +subMenus+ "</li>"
        else
          returnMenu=  returnMenu + breaker  + "<li class='top'>" + self.buildmenuitem(@menu, {:class=>html_link_class}, "") + "</li>"
        end

        breaker = breaker_val.html_safe
      end
    end

    #	<li class="top"><a href="#nogo1" class="top_link"><span>Home</span></a></li>

    return("<ul id='navi'>" + returnMenu + "</ul>").html_safe
      
  end
    
  def buildsubmenus(inputMenus, level)
    returnMenu = ""
    returnSubMenu = ""
    level = level + 1

    for eachmenu in inputMenus
      if eachmenu.menus.size > 0 then
        returnSubMenu = self.buildsubmenus(eachmenu.menus, level)
        returnSubMenu = "<li class='mid'>"+ self.buildmenuitem(eachmenu, {:class=>"fly"}, "")+ returnSubMenu+ "</li>"
      else
        returnSubMenu = "<li>" + self.buildmenuitem(eachmenu, {}, "") + "</li>"
      end
      returnMenu = returnMenu + returnSubMenu
    end

    if level == 1 then
      returnMenu = "<ul class='sub'>" + returnMenu + "</ul>"
    end
    if level == 2 then
      returnMenu =  "<ul>" + returnMenu +"</ul>"
    end
    if level > 2 then
      returnMenu =  "<ul>" + returnMenu +"</ul>"
    end
    return returnMenu   
  end
    
  def get_page_name
  
    return @page.name rescue @page_name rescue ""
  
    
  end

  def redirect_back_or_default(path)
    redirect_to :back
  rescue ActionController::RedirectBackError
    redirect_to path
  end

end
