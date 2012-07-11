class PagesController < ApplicationController
  # GET /pages
  # GET /pages.json

 # uses_tiny_mce(:options => AppConfig.default_mce_options, :only => [:new, :edit])
  uses_tiny_mce(:options => AppConfig.full_mce_options, :only => [:new, :edit])


  def index
    session[:mainnav_status] = true
    @pages = Page.all

    respond_to do |format|
      format.html # index.html.erb
      format.json  { render :json => @pages }
    end
  end

  # GET /pages/1
  # GET /pages/1.json
  def show
    @page = Page.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json  { render :json => @page }
    end
  end

  # GET /pages/new
  # GET /pages/new.json
  def new
    @page = Page.new

    respond_to do |format|
      format.html # new.html.erb
      format.json  { render :json => @page }
    end
  end

  # GET /pages/1/edit
  def edit
    session[:mainnav_status] = true
    @page = Page.find(params[:id])
    @item_edit =  @page
    @menu_location=[["Top",1] , ["Side",2]]
  end

  # POST /pages
  # POST /pages.json
  def create
    @page = Page.new(params[:page])

    respond_to do |format|
      if @page.save
        format.html { redirect_to(@page, :notice => 'Page was successfully created.') }
        format.json  { render :json => @page, :status => :created, :location => @page }
      else
        format.html { render :action => "new" }
        format.json  { render :json => @page.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /pages/1
  # PUT /pages/1.json
  def update
    @page = Page.find(params[:id])

    respond_to do |format|
      if @page.update_attributes(params[:page])
        format.html { redirect_to(:action =>"edit", :notice => 'Page was successfully updated.') }
        format.json  { head :ok }
      else
        format.html { render :action => "edit" }
        format.json  { render :json => @page.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /pages/1
  # DELETE /pages/1.json
  def destroy
    @page = Page.find(params[:id])
    @page.destroy

    respond_to do |format|
      format.html { redirect_to(pages_url) }
      format.json  { head :ok }
    end
  end


  def create_empty_record
    @page = Page.new
    @page.title="New Page"
    @page.body="Edit Me"
    @page.full_screen=false
    @page.save
    redirect_to(:controller=>"pages", :action=>"edit", :id=>@page)
  end

  def get_sliders_list
        @page = Page.find(params[:page_id])
        render :partial=>"slider_list.html", :collection=>@page.sliders
  end
end
