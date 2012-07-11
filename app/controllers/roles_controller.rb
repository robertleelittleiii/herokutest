class RolesController < ApplicationController

  def index
   @roles = Role.find(:all, :order => :name)

  respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @roles }
  end
end
  def edit
    @role = Role.find(params[:id])

      respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @role }
      end
  end

  def new
    @role = Role.new

     respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @role }
     end
  end

  def view
        @role = Role.find(params[:id], :include => :rights)
        @rights = Right.find(:all, :order => :name)

      respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @role }
       end
  end

def record
  @role = Role.find(params[:id])
  @role.rights.create(params[:right])
  redirect_to :action => 'view', :id => params[:id]
end

def record2
		@role = Role.find(params[:id])
		@rights = (Right.find(params[:role][:right_ids]) if params[:role][:right_ids])
		@role.rights = (@rights || [])
		if @role.save
      flash[:notice] = "Roles rights were successfully updated."
  redirect_to :action => 'view', :id => params[:id]
		else
      flash[:error] = 'There was a problem updating the roles for this user.'
  redirect_to :action => 'view', :id => params[:id]
		end
	end

  def show
        @role = Role.find(params[:id])

      respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @role }
       end
  end

  def create
    @role = Role.new(params[:role])

    respond_to do |format|
      if @role.save
        flash[:notice] = "role #{@role.name} was successfully created."
        format.html { redirect_to(:action=>'index') }
        format.xml  { render :xml => @role, :status => :created,
                             :location => @role }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @role.errors,
                             :status => :unprocessable_entity }
      end
    end
  end

  def update
    @role = Role.find(params[:id])

    respond_to do |format|
      if @role.update_attributes(params[:role])
        flash[:notice] = "role #{@role.name} was successfully updated."
        format.html { redirect_to(:action=>'index') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @role.errors,
                             :status => :unprocessable_entity }
      end
    end
  end

 def destroy
  @role = Role.find(params[:id])
  begin
    @role.destroy
      flash[:notice] = "role #{role.name} deleted"
  rescue Exception => e
    flash[:notice] = e.message
  end
  respond_to do |format|
    format.html { redirect_to(roles_url) }
    format.xml { head :ok }
  end

end

end
