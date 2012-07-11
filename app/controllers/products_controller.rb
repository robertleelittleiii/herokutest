class ProductsController < ApplicationController
  
    uses_tiny_mce(:options => AppConfig.full_mce_options, :only => [:new, :edit])

  
  # GET /products
  # GET /products.json
  def index
    session[:mainnav_status] = true

    @products = Product.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render :json=>@products} 
    end
  end

  # GET /products/1
  # GET /products/1.json
  def show
    @product = Product.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render :json=>@product }
    end
  end

  # GET /products/new
  # GET /products/new.json
  def new
    @product = Product.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render :json=>@product}
    end
  end

  # GET /products/1/edit
  def edit
    session[:mainnav_status] = true

    @product = Product.find(params[:id])
    @colors =  @product.product_details.select("distinct `color`").collect{|x| x.color }

  end

  # POST /products
  # POST /products.json
  def create
    @product = Product.new(params[:product])

    respond_to do |format|
      if @product.save
        format.html { redirect_to @product, :notice=>"Product was successfully created." }
        format.json { render :json=>@product, :status=>:created, :location=>@product }
      else
        format.html { render :action=>"new" }
        format.json { render :json=>@product.errors, :status=>:unprocessable_entry }
      end
    end
  end

  # PUT /products/1
  # PUT /products/1.json
  def update
    @product = Product.find(params[:id])

    respond_to do |format|
      if @product.update_attributes(params[:product])
        format.html { redirect_to(:action =>"edit", :notice => 'Product description was successfully updated.')}
        format.json { head :ok }
      else
        format.html { render :action=>"edit" }
        format.json { render :json=>@product.errors, :status=>"unprocessable_entry" }
      end
    end
  end

  # DELETE /products/1
  # DELETE /products/1.json
  def destroy
    @product = Product.find(params[:id])
    @product.destroy

    respond_to do |format|
      format.html { redirect_to products_url }
      format.json { head :ok }
    end
  end
  
  # CREATE_EMPTY_RECORD /products/1
  # CREATE_EMPTY_RECORD /products/1.json

  def create_empty_record
    @product = Product.new
    @product.product_name="New Product"
    @product.product_description = "Edit Me."
    @product.unit_price = 0
    @product.msrp = 0
    @product.save
    
    redirect_to(:controller=>:products, :action=>:edit, :id=>@product)
  end

  def show_detail 
    @product = Product.find(params[:id])
    render :partial=>"detail_list"
  end
  
  def product_table
    @objects = current_objects(params)
    @total_objects = total_objects(params)
    render :layout => false
  end
  
    
    
  def add_image
    @product = Product.find(params[:id])
    @colors =  @product.product_details.select("distinct `color`").collect{|x| x.color }

    format = params[:format]
    image=params[:image]
    if image.size > 0
      @image = Picture.new(:image=>image)
      @image.position=999
      @image.save
      @product.pictures << @image
    end
    #  respond_to do |format|  
    #          format.html { render :nothing => true}
    #          format.js   { render :nothing => true }  
    #  end  
  
    respond_to do |format|
      flash[:notice] = 'Picture was successfully added.'
      format.js do
        responds_to_parent do
          render :update do |page|
            page.replace_html("images" , :partial => "images" , :object => @product.pictures)
            if @product.pictures.count > 10
              page.hide "imagebutton"
            end
            page.hide "loader_progress"
            page.show "upload-form"
            # page.call "alert", "test"
            page.call "updateBestinplaceImageTitles"
            #           page.call("jQuery('#loader_progress').toggle();")
            # page.call("jQuery('#upload-form').toggle();")
            # page.call("jQuery('.imageSingle .best_in_place').best_in_place();");
            page.visual_effect :highlight, "image_#{@image.id}"
            page[:images].show if @product.pictures.count == 1
          end
        end
      end

      format.html { redirect_to :action => 'show', :id => params[:id] }
    end
  end

  def delete_image
    @product = Product.find(params[:incoming_id])
    @image = Picture.find(params[:id])
    @image.destroy
   
    
    respond_to do |format|
      format.js if request.xhr?
      format.html {redirect_to :action => 'show', :id=>params[:menu_id]}
    end
  end


  def destroy_image
    @image = Picture.find(params[:id])
    @image.destroy
    redirect_to :action => 'show', :id => params[:menu_id]
  end

  def update_image_order
    params[:album].each_with_index do |id, position|
      #   Image.update(id, :position => position)
      Picture.reorder(id,position)
    end
    render :nothing => true

  end
    
  def update_checkbox_tag
    @product=Product.find(params[:id])
    @tag_name=params[:tag_name] || "tag_list"
    if params[:current_status]== "false" then
      @product.send(@tag_name).remove(params[:field])
    else
      @product.send(@tag_name).add(params[:field])
    end
    @product.save

    render(:nothing => true)

    #   respond_to do |format|
    #       format.js if request.xhr?
    #       format.html {redirect_to :action => 'show', :id=>params[:id]}
    #  end

      
  end
    
  def render_category_div
    @product=Product.find(params[:id])
    render(:partial=>"category_div")
    
  end
    
    
  def render_image_section
    @product=Product.find(params[:id])
    @colors =  @product.product_details.select("distinct `color`").collect{|x| x.color }

    render(:partial=>"image_section")
    
  end
    
    
    
    
    
  private
 
  def current_objects(params={})
    current_page = (params[:iDisplayStart].to_i/params[:iDisplayLength].to_i rescue 0)+1
    @current_objects = Product.paginate :page => current_page, 
      :order => "#{datatable_columns(params[:iSortCol_0])} #{params[:sSortDir_0] || "DESC"}", 
      :conditions => conditions,
      :per_page => params[:iDisplayLength]
    
   # @current_objects = Product.select("products.*").
   #   where(conditions).
   #   order("#{datatable_columns(params[:iSortCol_0])} #{params[:sSortDir_0] || "DESC"}")
  
  
  end
    

  def total_objects(params={})
    @total_objects = Product.count
  end

  def datatable_columns(column_id)
    case column_id.to_i
    when 0
      return "products.supplier_product_id"
    when 1
      return "products.product_name"
    else
      return "products.product_description"
    end
  end

  def conditions
    conditions = []
    conditions << "(products.product_name LIKE '%#{params[:sSearch]}%' OR products.product_description LIKE '%#{params[:sSearch]}%' OR products.supplier_product_id LIKE '%#{params[:sSearch]}%')" if(params[:sSearch])
    return conditions.join(" AND ")
  end
  
end
