class OrdersController < ApplicationController
  # GET /orders
  # GET /orders.json
  def index
    @orders = Order.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render :json=>@orders} 
    end
  end

  # GET /orders/1
  # GET /orders/1.json
  def show
    @order = Order.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render :json=>@order }
    end
  end

  # GET /orders/new
  # GET /orders/new.json
  def new
    @order = Order.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render :json=>@order}
    end
  end

  # GET /orders/1/edit
  def edit
    @order = Order.find(params[:id])
  end

  # POST /orders
  # POST /orders.json
  
  def create
    @order = Order.new(params[:order])

    respond_to do |format|
      if @order.save
        format.html { redirect_to @order, :notice=>"Order was successfully created." }
        format.json { render :json=>@order, :status=>:created, :location=>@order }
      else
        format.html { render :action=>"new" }
        format.json { render :json=>@order.errors, :status=>:unprocessable_entry }
      end
    end
  end

  # PUT /orders/1
  # PUT /orders/1.json
  def update
    @order = Order.find(params[:id])

    respond_to do |format|
      if @order.update_attributes(params[:order])
        format.html { redirect_to @order, :notice=>"Order was successfully updated."}
        format.json { head :ok }
      else
        format.html { render :action=>"edit" }
        format.json { render :json=>@order.errors, :status=>"unprocessable_entry" }
      end
    end
  end

  # DELETE /orders/1
  # DELETE /orders/1.json
  def destroy
    @order = Order.find(params[:id])
    @order.destroy

    respond_to do |format|
      format.html { redirect_to orders_url }
      format.json { head :ok }
    end
  end
  
  # CREATE_EMPTY_RECORD /orders/1
  # CREATE_EMPTY_RECORD /orders/1.json

  def create_empty_record
    $hostfull=request.protocol + request.host_with_port

    @cart=Cart.get_cart("cart"+session[:session_id])
    
    @order = Order.new
    @order.add_line_items_from_cart(@cart, $hostfull)
    @order.user = User.find_by_id(session[:user_id])
    @order.ip_address = request.remote_ip
    # @order.email = @order.user.name
    @order.save
    
    redirect_to(:controller=>:orders, :action=>:edit, :id=>@order)
  end


  
  def enter_order
    $hostfull = request.protocol + request.host_with_port

    @user = User.find_by_id(session[:user_id])
    @page_title = "order success"
    @page = Page.find_all_by_title(@page_title).first

    if params[:order].blank? then
      @order=Order.new
    else
      
    
      @cart=Cart.get_cart("cart"+session[:session_id])

      @order = Order.new(params[:order])
      @order.add_line_items_from_cart(@cart, $hostfull)
      @order.shipping_method = @cart.shipping_type
      @order.sales_tax = @cart.calc_tax
      @order.shipping_cost = @cart.calc_shipping[@cart.shipping_type]
      @order.user = User.find_by_id(session[:user_id])
      @order.ip_address = request.remote_ip

      respond_to do |format|
        if @order.save
          if @order.purchase(@cart)
            empty_cart
            format.html { redirect_to(:controller=>:orders, :action=>:order_success, :id=>@order)}
            # format.html {render :action => "order_success"}
          else
            format.html { render :action => "enter_order", :params=>params[:order]}
          end
          #  format.html { redirect_to @order, :notice=>"Order was successfully created." }
          #  format.json { render :json=>@order, :status=>:created, :location=>@order }
        else
          format.html { render :action => "enter_order", :params=>params[:order] }
          format.json { render :json=>@order.errors, :status=>:unprocessable_entry }
        end
      end
    end

  end
  
  def order_success 
    @page_title = "order success"
    @order = Order.find(params[:id])
    @user = User.find_by_id(session[:user_id])
    @page = Page.find_all_by_title(@page_title).first
     
  end
  
  def invoice_slip
    @page_title = "order success"

    @order = Order.find(params[:id])
    @user = User.find_by_id(session[:user_id])
    @page = Page.find_all_by_title(@page_title).first
    
    render :partial=>"invoice_report", :layout=>false
  end
  
  
  def user_orders
    @user = User.find_by_id(session[:user_id])
    @orders = @user.orders
    render :action=>:index
  end
  
end
