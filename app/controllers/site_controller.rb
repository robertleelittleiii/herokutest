

class SiteController < ApplicationController

  before_filter :find_cart, :except => :empty_cart

  uses_tiny_mce(:options => AppConfig.default_mce_options, :only => [:new, :edit])

  def index
    
    session[:mainnav_status] = false
    @page = Page.find_by_title("Home")||"'Home' not found."
    @menu = @page.menu rescue nil
        
    session[:parent_menu_id] = @menu.id rescue session[:parent_menu_id] = 0
    
        
    puts("parent menu id:", session[:parent_menu_id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @page }
    end
  end

  def show_page
    session[:mainnav_status] = false
    @page = Page.find(params[:id])
    @menu = @page.menu
    
    if params[:top_menu] 
      session[:parent_menu_id] = @menu.id rescue 0
    end
        
    # puts("parent menu id:", session[:parent_menu_id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @page }
    end

  end

  
  def show_prop_slideshow
    @properties = Property.find_properties(params[:realtor_id])
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @page }
    end
  end

  def show_prop_slideshow_partial
    @properties = Property.find_properties(params[:realtor_id])
    render :partial => "show_prop_slideshow", :format=>"html"
  end
  
  def show_products
    session[:mainnav_status] = false
    session[:last_catetory] = request.env['REQUEST_URI']
    @page_name=Menu.find(session[:parent_menu_id]).name rescue ""
    
    @products_per_page = Settings.products_per_page.to_i || 8
    @category_id = params[:category_id] || ""
    @department_id = params[:department_id] || ""
    @category_children = params[:category_children] || false
    puts("SubCats: #{@category_children} ")
    begin 
      if @category_children == "true" then
        @categories =  create_menu_lowest_child_list(@category_id, nil,false)
        puts("categories: #{@categories.inspect} ")
        @products = Product.where(:product_active=>true).tagged_with(@categories, :any=>true, :on=>:category).tagged_with(@department_id, :on=>:department).order("created_at DESC").order("product_ranking DESC")

      else
        if @category_id == ""  then
          @products = Product.where(:product_active=>true).order("created_at DESC").order("product_ranking DESC")
        else
          @products = Product.where(:product_active=>true).tagged_with(@category_id, :on=>:category).tagged_with(@department_id, :on=>:department).order("created_at DESC").order("product_ranking DESC")
        end
      end
    rescue
      @products=Product.all
    end
    
    @product_count = @products.length

    @products = Kaminari.paginate_array(@products).page(params[:page]).per(@products_per_page)
    
    @product_first = params[:page].blank? ? "1" : (params[:page].to_i*@products_per_page - 7)
    
    @product_last = params[:page].blank? ? @products.length : ((params[:page].to_i*@products_per_page) - @products_per_page) + @products.length || @products.length

    
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @page }
    end
  end
  
  def get_sizes_for_color 
    
    @product = Product.find(params[:id]) 
    @product_sizes = @product.product_details.select("distinct `size`, `units_in_stock`").where("`color` = '#{params[:color]}'")  || [{:size=>'n/a', :units_in_stock=>"0"}]
    render :partial=>"sizes_list.html"
  end
  
  def product_detail
    session[:mainnav_status] = false
    if params[:id].blank? then
      @product = Product.first
    else
      @product = Product.find(params[:id]) 
 
    end
  
    @product_details = @product.product_details
    @product_colors = @product_details.group(:color).where(:sku_active=>true) || "(not available)"
    @product_sizes = @product_details.select("distinct `size`, `units_in_stock`").where("`color` = '#{@product_colors[0].color}'").where(:sku_active=>true)  || [{:size=>'n/a', :units_in_stock=>"0"}] rescue [{:size=>'n/a', :units_in_stock=>"0"}]
  end
  
  #
  #
  #check out
  #
  #
  def check_out
    find_cart

    @shipping_methods = [["Ground",0] , ["2 Day",1], ["Next Day",2], ["Pick Up Store",3]]
    if @cart.items.empty?
      redirect_to(:controller => "site", :action => "index")
    else
      #@cart.hide
      #@cart.set_shipping(@cart.calc_shipping)
      #@order = Order.new


     
    end
  end
  
  #
  #  Shopping Cart 
  #
  
  
  def add_to_cart
    @cart=Cart.get_cart("cart"+session[:session_id])

    #    @cart = Cart.get_cart(session[:cart])
    #    session[:cart] = @cart.id
    #  puts("cart id: #{@cart.id}")
       
    
    @product_detail=ProductDetail.where(:product_id=>params[:id], :color=>params[:color], :size=>params[:size]).first()
    # puts("Product in Add: #{@product_detail.product.inspect}")
    #  puts("Product Detail In Add: #{@product_detail.inspect}")
    inventory_item_description=params.map {|k,vs| vs.map {|v| "#{k}:#{v}"}}.join(",")
    begin
      @current_item = @cart.add_product(@product_detail.product, @product_detail, params[:quantity])
      puts("Quantity Ordered: #{@current_item.quantity.inspect}")
      if @current_item.quantity >= @product_detail.units_in_stock  then
        puts("cart quantity:#{@current_item.quantity }, unit in stock: #{@product_detail.units_in_stock}")
        flash.now[:warning] ='Your request exceeds current inventory, your quantity has been reduced to what we have in stock.'
        # @current_item.quantity = @product_detail.units_in_stock.to_i
      end
    
      @flash_message = flash.now[:warning]
    rescue 
      @flash_message = "That product is currently unavailable."

    end
    respond_to do |format|
      format.json  { head :ok }
      format.html { render :text=>@flash_message }
    end
  end

  def hide_cart
    find_cart
    unless not @cart.visable then
      @cart.hide
      respond_to do |format|
        format.js if request.xhr?
        format.html {redirect_to :controller => 'store', :action => 'store_list'}
      end
    end
  end

  
  def show_cart
    # @cart = (session[:cart] ||= Cart.new)
    @cart=Cart.get_cart("cart"+session[:session_id])
    #   @cart = Cart.get_cart(session[:cart])
    #    puts("cart id: #{@cart.id}")

    unless @cart.visable then
      @cart.show
      respond_to do |format|
        format.js if request.xhr?
        format.html 
      end
    end
  end

  def toggle_cart
    find_cart
    if @cart.visable then
      hide_cart
    else
      show_cart
    end
  end
    
  def get_shopping_cart_item_info 
    find_cart
    @checkout_cart_item = @cart.items[params[:item_no].to_i]
    render :partial=>"/site/shopping_cart_item_info.html", :locals=>{:checkout_cart_item=>@checkout_cart_item}
  end
  
  def get_cart_summary_body 
    find_cart
    @checkout_cart = @cart
    render :partial=>"/site/cart_summary_body.html", :locals=>{:checkout_cart=>@checkout_cart}
  end
  
  def get_cart_contents 
    find_cart
    @checkout_cart = @cart
    render :partial => "checkout_cart_item" , :collection => @checkout_cart.items
  end
   
  def get_shopping_cart_info 
    find_cart
    render :partial=>"/site/shopping_cart_info.html"
  end
  
  
    
  def increment_cart_item
    find_cart
    @current_item_counter=params[:current_item]
    @current_item=@cart.items[@current_item_counter.to_i]
    @current_item.increment_quantity
    @cart.save

    if @current_item.quantity >= @current_item.product_detail.units_in_stock  then
      puts("cart quantity:#{@current_item.quantity }, unit in stock: #{@current_item.product_detail.units_in_stock}")
      flash.now[:warning] ='Your request exceeds current inventory, your quantity has been reduced to what we have in stock.'
      # @current_item.quantity = @product_detail.units_in_stock.to_i
    end
    
    @flash_message = flash.now[:warning]
      
    respond_to do |format|
      format.json  { head :ok }
      format.html { render :text=>@flash_message }
    end

  end

  def decrement_cart_item
    find_cart
    @current_item_counter=params[:current_item]
    @current_item=@cart.items[@current_item_counter.to_i]
    @current_item.decrement_quantity
    @cart.save
    respond_to do |format|
      format.json  { head :ok }
      format.html {render :nothing=>true}
    end
  end

  def delete_cart_item
    find_cart
    @current_item_counter=params[:current_item]
    @current_item=@cart.items.delete_at(@current_item_counter.to_i)
    @cart.save

    respond_to do |format|
      format.json  { head :ok }
      format.html {render :nothing=>true}
    end
  end

  def empty_cart
    find_cart
    @cart.delete
    session[:cart] = nil
    find_cart
    
    #    render(:nothing => true)

    #    redirect_to_index

    #        find_cart
    #    @cart=nil
    #    session[:cart] = nil
    respond_to do |format|
      format.js if request.xhr?
      format.html {redirect_to :controller => 'site', :action => 'index'}
    end

    
    def save_order
      $hostfull = request.protocol + request.host_with_port

   
      session[:mainnav_status] = false
  
      @order = Order.new(params[:order])
      @order.add_line_items_from_cart(@cart, $hostfull)
      @order.user = User.find_by_id(session[:user_id])
      @order.ip_address = request.remote_ip
      @order.email = @order.user.name
      @order.cart_type="CreditCard"
      
      if @order.save
        return_response=@order.purchase
        if return_response.success?
          flash[:notice] = "Thank you for your Order!!"
          session[:cart] = nil
          redirect_to( :action => :success, :controller=>"orders", :id=>@order.id)
          #     redirect_to( :action => :customer_detail, :controller=>"orders", :id=>@order.id)

        else
          flash[:notice] = "Transaction failed! <br> <br> <br>" + return_response.message
          render :action => 'checkoutcc'

        end

        #        session[:cart] = nil
        #    redirect_to_index("Thank you for your order")
      else
        render :action => 'checkoutcc'
      end

    end

  end

  private 
  
  
  def find_cart
    #  @cart = (session[:cart] ||= Cart.new)
    session[:create]=true
    
    @cart=Cart.get_cart("cart"+session[:session_id]) rescue  Rails.cache.write("cart"+session[:session_id],{}, :expires_in => 15.minutes)
    #   @cart = Cart.get_cart(session[:cart])
    #    session[:cart] = @cart.id
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
    
  
  
  protected

  def authorize
  end

  def authenticate
  end
end
