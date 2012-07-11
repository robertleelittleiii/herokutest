class <%= controller_class_name %>Controller < ApplicationController
  # GET <%= route_url %>
  # GET <%= route_url %>.json
  def index
    @<%= plural_table_name %> = <%= orm_class.all(class_name) %>

    respond_to do |format|
      format.html # index.html.erb
      format.json { render :json=>@<%= plural_table_name %>} 
    end
  end

  # GET <%= route_url %>/1
  # GET <%= route_url %>/1.json
  def show
    @<%= singular_table_name %> = <%= orm_class.find(class_name, "params[:id]") %>

    respond_to do |format|
      format.html # show.html.erb
      format.json { render :json=>@<%= singular_table_name %> }
    end
  end

  # GET <%= route_url %>/new
  # GET <%= route_url %>/new.json
  def new
    @<%= singular_table_name %> = <%= orm_class.build(class_name) %>

    respond_to do |format|
      format.html # new.html.erb
      format.json { render :json=>@<%= singular_table_name %>}
    end
  end

  # GET <%= route_url %>/1/edit
  def edit
    @<%= singular_table_name %> = <%= orm_class.find(class_name, "params[:id]") %>
  end

  # POST <%= route_url %>
  # POST <%= route_url %>.json
  def create
    @<%= singular_table_name %> = <%= orm_class.build(class_name, "params[:#{singular_table_name}]") %>

    respond_to do |format|
      if @<%= orm_instance.save %>
        format.html { redirect_to @<%= singular_table_name %>, :notice=>"<%= human_name %> was successfully created." }
        format.json { render :json=>@<%= singular_table_name %>, :status=>:created, :location=>@<%= singular_table_name %> }
      else
        format.html { render :action=>"new" }
        format.json { render :json=>@<%= orm_instance.errors %>, :status=>:unprocessable_entry }
      end
    end
  end

  # PUT <%= route_url %>/1
  # PUT <%= route_url %>/1.json
  def update
    @<%= singular_table_name %> = <%= orm_class.find(class_name, "params[:id]") %>

    respond_to do |format|
      if @<%= orm_instance.update_attributes("params[:#{singular_table_name}]") %>
        format.html { redirect_to @<%= singular_table_name %>, :notice=>"<%= human_name %> was successfully updated."}
        format.json { head :ok }
      else
        format.html { render :action=>"edit" }
        format.json { render :json=>@<%= orm_instance.errors %>, :status=>"unprocessable_entry" }
      end
    end
  end

  # DELETE <%= route_url %>/1
  # DELETE <%= route_url %>/1.json
  def destroy
    @<%= singular_table_name %> = <%= orm_class.find(class_name, "params[:id]") %>
    @<%= orm_instance.destroy %>

    respond_to do |format|
      format.html { redirect_to <%= index_helper %>_url }
      format.json { head :ok }
    end
  end
  
   # CREATE_EMPTY_RECORD <%= route_url %>/1
   # CREATE_EMPTY_RECORD <%= route_url %>/1.json

  def create_empty_record
    @<%= singular_table_name %> = <%= orm_class.build(class_name) %>
    @<%= singular_table_name %>.save
    
    redirect_to(:controller=>:<%= plural_table_name %>, :action=>:edit, :id=>@<%= singular_table_name %>)
  end

  
end
