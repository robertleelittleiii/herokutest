class ProductDetailsController < ApplicationController
  # GET /product_details
  # GET /product_details.json
  def index
    @product_details = ProductDetail.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render :json=>@product_details} 
    end
  end

  # GET /product_details/1
  # GET /product_details/1.json
  def show
    @product_detail = ProductDetail.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render :json=>@product_detail }
    end
  end

  # GET /product_details/new
  # GET /product_details/new.json
  def new
    @product_detail = ProductDetail.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render :json=>@product_detail}
    end
  end

  # GET /product_details/1/edit
  def edit
    if params[:request_type]== "nothing" then
          render :nothing=>true
    else
          @product_detail = ProductDetail.find(params[:id])

    end
  end

  # POST /product_details
  # POST /product_details.json
  def create
    @product_detail = ProductDetail.new(params[:product_detail])

    respond_to do |format|
      if @product_detail.save
        format.html { redirect_to @product_detail, :notice=>"Product detail was successfully created." }
        format.json { render :json=>@product_detail, :status=>:created, :location=>@product_detail }
      else
        format.html { render :action=>"new" }
        format.json { render :json=>@product_detail.errors, :status=>:unprocessable_entry }
      end
    end
  end

  # PUT /product_details/1
  # PUT /product_details/1.json
  def update
    @product_detail = ProductDetail.find(params[:id])

    respond_to do |format|
      if @product_detail.update_attributes(params[:product_detail])
        format.html { redirect_to @product_detail, :notice=>"Product detail was successfully updated."}
        format.json { head :ok }
      else
        format.html { render :action=>"edit" }
        format.json { render :json=>@product_detail.errors, :status=>"unprocessable_entry" }
      end
    end
  end

  # DELETE /product_details/1
  # DELETE /product_details/1.json
  def destroy
    @product_detail = ProductDetail.find(params[:id])
    @product_detail.destroy

    respond_to do |format|
      format.html { redirect_to product_details_url }
      format.json { head :ok }
    end
  end
  
  # CREATE_EMPTY_RECORD /product_details/1
  # CREATE_EMPTY_RECORD /product_details/1.json

  def duplicate_record
    @old_product_detail = ProductDetail.find(params[:old_id])
    
    @product_detail = ProductDetail.new
    @product_detail.product_id = @old_product_detail.product_id
    @product_detail.units_in_stock = 0
    @product_detail.units_on_order = 0
    @product_detail.color= @old_product_detail.color
    @product_detail.inventory_key = @old_product_detail.inventory_key
    @product_detail.size = "new"
    @product_detail.save
    
    respond_to do |format|
      format.html { head :ok }
      format.json { head :ok }
    end
  end
  
  def create_empty_record
    @product_detail = ProductDetail.new
    @product_detail.product_id = params[:product_id] rescue nil
    @product_detail.units_in_stock = 0
    @product_detail.units_on_order = 0
    @product_detail.color = "new color"
    @product_detail.save
    

    redirect_to(:controller=>:product_details, :action=>:edit, :request_type=>params[:request_type], :id=>@product_detail)
    #   redirect_to(:controller=>:product_details, :action=>:edit, :id=>@product_detail)
  end

  
end
