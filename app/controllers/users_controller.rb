class UsersController < ApplicationController
  # GET /users
  # GET /users.xml
 
  def record
		@user = User.find(params[:id])
		@roles = (Role.find(params[:user][:role_ids]) if params[:user][:role_ids])
		@user.roles = (@roles || [])
		if @user.save
      flash[:notice] = "Users roles were successfully updated."
      redirect_to :action => 'view', :id => params[:id]
		else
      flash[:error] = 'There was a problem updating the roles for this user.'
      redirect_to :action => 'view', :id => params[:id]
		end
	end


  def index
    @users = User.find(:all, :order => :name)

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @users }
    end
  end

  # GET /users/1
  # GET /users/1.xml
  def show
    @user = User.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @user }
    end
  end

  # GET /users/new
  # GET /users/new.xml
  def new
    @user = User.new
    
    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @user }
    end
  end

  # GET /users/1/edit
  def edit
    @user = User.find(params[:id])
    
    
  end

  # POST /users
  # POST /users.xml



  def selfcreate
    puts "selfcreate"

        @user = User.new(params[:user])
  end


  def create
    @user = User.new(params[:user])
       puts "testing"
      logger.error("controller #{self.class.controller_path}")
      logger.info("action: #{action_name}")
      @newAttributes = UserAttribute.new()

        @user.user_attribute = @newAttributes
        @newAttributes.save()
        
    respond_to do |format|
      if @user.save

        flash[:notice] = "User #{@user.name} was successfully created."
        format.html { redirect_to(:action=>'index') }
        format.xml  { render :xml => @user, :status => :created,
                             :location => @user }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @user.errors,
                             :status => :unprocessable_entity }
      end
    end
  end

 def view
        @user = User.find(params[:id], :include => :roles)
        @roles = Role.find(:all, :order => :name)

      respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @role }
       end
  end




# def add_attributes
#    @user = User.find(params[:id], :include => :user_attribute)
#    @newAttributes = UserAttribute.create
#    @user.user_attribute = @newAttributes
#    #@user.shop = Shop.create(:name => (@user.name +" Store"))
#    @user.save
#
#   redirect_to :action => 'view_attributes', :id => params[:id]
#
#
# end

  # PUT /users/1
  # PUT /users/1.xml
  def update
    @user = User.find(params[:id])

    respond_to do |format|
      if @user.update_attributes(params[:user])
        flash[:notice] = "User #{@user.name} was successfully updated."
        format.html { redirect_to(:action=>'index') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @user.errors,
                             :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /users/1
  # DELETE /users/1.xml
 def destroy
  @user = User.find(params[:id])
  begin
    @user.destroy
      flash[:notice] = "User #{user.name} deleted"
  rescue Exception => e
    flash[:notice] = e.message
  end
  respond_to do |format|
    format.html { redirect_to(users_url) }
    format.xml { head :ok }
  end

end
def view_attributes
       @user = User.find(params[:id], :include => :user_attribute)

      flash[:notice] = "User #{@user.name} has no attributes." if @user.user_attribute.nil?
      respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @role }
       end
  end

 def add_attributes
    @user = User.find(params[:id], :include => :user_attribute)
    @newAttributes = UserAttribute.create
    @user.user_attribute = @newAttributes
    #@user.shop = Shop.create(:name => (@user.name +" Store"))
    @user.save

   redirect_to :action => 'view_attributes', :id => params[:id]


 end


end
