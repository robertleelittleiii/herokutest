class SlidersController < ApplicationController
  uses_tiny_mce(:options => AppConfig.full_mce_options, :only => [:new, :edit])


  # GET /sliders
  # GET /sliders.json
  def index
    @sliders = Slider.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render :json=>@sliders} 
    end
  end

  # GET /sliders/1
  # GET /sliders/1.json
  def show
    @slider = Slider.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render :json=>@slider }
    end
  end

  # GET /sliders/new
  # GET /sliders/new.json
  def new
    @slider = Slider.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render :json=>@slider}
    end
  end

  # GET /sliders/1/edit
  def edit
    @slider = Slider.find(params[:id])
    
  end

  # POST /sliders
  # POST /sliders.json
  def create
    @slider = Slider.new(params[:slider])

    respond_to do |format|
      if @slider.save
        format.html { redirect_to @slider, :notice=>"Slider was successfully created." }
        format.json { render :json=>@slider, :status=>:created, :location=>@slider }
      else
        format.html { render :action=>"new" }
        format.json { render :json=>@slider.errors, :status=>:unprocessable_entry }
      end
    end
  end

  # PUT /sliders/1
  # PUT /sliders/1.json
  def update
    @slider = Slider.find(params[:id])

    respond_to do |format|
      if @slider.update_attributes(params[:slider])
        format.html { redirect_to(:action=>"edit", :notice=>"Slider was successfully updated.")}
        format.json { head :ok }
      else
        format.html { render :action=>"edit" }
        format.json { render :json=>@slider.errors, :status=>"unprocessable_entry" }
      end
    end
  end

  # DELETE /sliders/1
  # DELETE /sliders/1.json
  def destroy
    @slider = Slider.find(params[:id])
    @slider.destroy

    respond_to do |format|
      format.html { redirect_to sliders_url }
      format.json { head :ok }
    end
  end
  
  # CREATE_EMPTY_RECORD /sliders/1
  # CREATE_EMPTY_RECORD /sliders/1.json

  def create_empty_record
    @page = Page.find(params[:page_id]) || ""
    
    
    @slider = Slider.new
    @slider.page_id = params[:page_id] || ""
    @slider.slider_name = "Untitled Slider" + (@page.sliders.count + 1).to_s
    @slider.slider_order = @page.sliders.count + 1
    @slider.slider_type = 0
    @slider.slider_content = "Edit Me"
    @slider.save
    
    redirect_to(:controller=>:sliders, :action=>:edit, :id=>@slider, :notice=>"Slider was successfully created.")
  end

  def sort
    @sliders = Slider.where(:page_id=>params[:page_id])
    @sliders.each do |slider|
      slider.slider_order = params['slider'].index(slider.id.to_s) + 1
      puts(slider.slider_order, slider)
      slider.save
    end

    render :nothing => true
  end
  
end
