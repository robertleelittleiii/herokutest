class ImporterItemsController < ApplicationController
  # GET /importer_items
  # GET /importer_items.json
  def index
    @importer_items = ImporterItem.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render :json=>@importer_items} 
    end
  end

  # GET /importer_items/1
  # GET /importer_items/1.json
  def show
    @importer_item = ImporterItem.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render :json=>@importer_item }
    end
  end

  # GET /importer_items/new
  # GET /importer_items/new.json
  def new
    @importer_item = ImporterItem.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render :json=>@importer_item}
    end
  end

  # GET /importer_items/1/edit
  def edit
    @importer_item = ImporterItem.find(params[:id])
  end

  # POST /importer_items
  # POST /importer_items.json
  def create
    @importer_item = ImporterItem.new(params[:importer_item])

    respond_to do |format|
      if @importer_item.save
        format.html { redirect_to @importer_item, :notice=>"Importer item was successfully created." }
        format.json { render :json=>@importer_item, :status=>:created, :location=>@importer_item }
      else
        format.html { render :action=>"new" }
        format.json { render :json=>@importer_item.errors, :status=>:unprocessable_entry }
      end
    end
  end

  # PUT /importer_items/1
  # PUT /importer_items/1.json
  def update
    @importer_item = ImporterItem.find(params[:id])

    respond_to do |format|
      if @importer_item.update_attributes(params[:importer_item])
        format.html { redirect_to @importer_item, :notice=>"Importer item was successfully updated."}
        format.json { head :ok }
      else
        format.html { render :action=>"edit" }
        format.json { render :json=>@importer_item.errors, :status=>"unprocessable_entry" }
      end
    end
  end

  # DELETE /importer_items/1
  # DELETE /importer_items/1.json
  def destroy
    @importer_item = ImporterItem.find(params[:id])
    @importer_item.destroy

    respond_to do |format|
      format.html { redirect_to importer_items_url }
      format.json { head :ok }
    end
  end
  
   # CREATE_EMPTY_RECORD /importer_items/1
   # CREATE_EMPTY_RECORD /importer_items/1.json

  def create_empty_record
    @importer_item = ImporterItem.new
    @importer_item.save
    
    redirect_to(:controller=>:importer_items, :action=>:edit, :id=>@importer_item)
  end

  
end
