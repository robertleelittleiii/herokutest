class AdminController < ApplicationController
  # just display the form and wait for user to
  # enter a name and password

  def login
    session[:user_id] = nil
    if request.post?
      user = User.authenticate(params[:name], params[:password])
      if user
        session[:user_id] = user.id
        uri = session[:original_uri]
        session[:original_uri] = nil
        redirect_to(uri || { :action => "index" })
      else
        flash.now[:notice] = "Invalid user/password combination"
      end
    end
  end


  def logout
    session[:user_id] = nil
    flash[:notice] = "Logged out"
    redirect_to(:controller=>:site, :action => "index")
  end



  def index
    @user =  User.find_by_id(session[:user_id], :include => :user_attribute)
    @user_attributes = @user.user_attribute
    if @user.user_attribute.nil? then
     
      @newAttributes = UserAttribute.create

      @user.user_attribute = @newAttributes
    
      #@user.shop = Shop.create(:name => (@user.name +" Store"))
      @user.save
 
    end
    session[:mainnav_status] = true

  end
  
  def edit_ajax      
    if params[:pointer_class]=="UserAttribute" then
      @user = UserAttribute.find(params[:id])
    else
      @user = User.find(params[:id])
    end
    render :update do |page|
      page.replace_html "field_"+params[:field], :partial =>'edit_ajax.html'
    end
    # render(:layout=>false)
  end

  def cancel_ajax
    if params[:pointer_class]=="UserAttribute" then
      @user = UserAttribute.find(params[:id])
    else
      @user = User.find(params[:id])
    end
    @field=params[:field]
    render :update do |page|
      page.replace_html "field_"+params[:field], :partial =>'cancel_ajax.html'
    end
  end

  def update_ajax
    @alert_message=""
    if params[:pointer_class]=="UserAttribute" then
      @user = UserAttribute.find(params[:id])
      @user[params[:field]] = params[params[:field]]
      @user.save
    else
      @user = User.find(params[:id])
      # Note:  we must force this to be non generic for password to "kick off"  code in user object to set password params.
      if params[:field]=="password"
        if params[:password]==params["password_check"] then
          @user.password= params[:password]
        else
          #render(:update)
          @alert_message= "Password's did not match!!, Password not updated."
          #    flash.now[:notice] = "Password's didn't match!!, Password not updated"
        end
      else
        @user[params[:field]] = params[params[:field]]
      end
      @user.save
    end
    render :update do |page|
      page.replace_html "field_"+params[:field], :partial =>'update_ajax.html'
    end
    # render(:layout => false)
  
  end
  def site_settings

    if params.count > 2 then
      # we are doing an update on the site settings
      eval("Settings." + params["settings"].first[0] + "='" + params["settings"].first[1] +"'"   ) rescue ""
    else
      @settings = Settings.all 
    end
   
    respond_to do |format|
      format.json  { head :ok }
      format.html 
    end  
    
    
  end

 def reload_rails_env
   
 # Rails::ConsoleMethods.reload!
  
 end
     
  def toggle_index
    begin
      FileUtils.mv 'public/index.html', 'public/index.off'
    rescue
      FileUtils.mv  'public/index.off',  'public/index.html'
    end
    respond_to do |format|
      format.json  { head :ok }
      format.html {redirect_to :action => 'site_settings', :id=>params[:product_id]}
    end  
  end

  def reprocess_product_images
    @products = Product.all
    
    @products.each do |product|
      product.pictures.each do |picture|
      
        picture.image.recreate_versions!     
      end
    end
    respond_to do |format|
      format.json  { head :ok }
      format.html {redirect_to :action => 'site_settings', :id=>params[:product_id]}
    end  
  end
end
