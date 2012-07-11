class ApplicationController < ActionController::Base

  before_filter :redis_running,
    :authenticate,
    :authorize,
    :except => :login

           
  session :session_key => '_siinknyc_session_id'
  helper :all # include all helpers, all the time
  # See ActionController::RequestForgeryProtection for details
  # Uncomment the :secret if you're not using the cookie session store
  protect_from_forgery :secret => '8c3e099237e6366fd2f5366e9c430e79'
  # See ActionController::Base for details
  # Uncomment this to filter the contents of submitted sensitive data parameters
  # from your application log (in this case, all fields with names like "passwor...*TRUNC*
  # filter_parameter_logging :password

  layout Proc.new { |controller| controller.request.xhr? ? nil : 'application' }


  def edit_ajax
    @item_edit= Kernel.const_get(params[:pointer_class]).find(params[:id])
    @field=params[:field]
    puts(@item_edit)
    puts(@field)
    render :update do |page|
      page.replace_html "field_"+params[:field], :partial =>'/inline_edits/edit_ajax.html'
    end
  end

  def cancel_ajax
    @item_edit= Kernel.const_get(params[:pointer_class]).find(params[:id])
    @field=params[:field]

    render :update do |page|
      page.replace_html "field_"+params[:field], :partial =>'/inline_edits/cancel_ajax.html'
    end
  end

  def update_ajax
    @field=params[:field]

    if params[:pointer_class]=="Cart"then
      @item_edit = Cart.get_cart("cart"+session[:session_id])
      @alert_message=""
      
      @item_edit.send(params[:field]+"=",params[params[:field]].to_i)
      @item_edit.save

      render :nothing=>true
    else
      
      @item_edit= Kernel.const_get(params[:pointer_class]).find(params[:id])
      @alert_message=""
      @item_edit[params[:field]] = params[params[:field]]
      @item_edit.save

      render :update do |page|
        page.replace_html "field_"+params[:field], :partial =>'/inline_edits/update_ajax.html'
      end
    end


      
  end


  def update_checkbox
    @item_edit=Kernel.const_get(params[:pointer_class]).find(params[:id])
    @item_edit[params[:field]] = params[:current_status]=="true"
    @item_edit.save
    render :update do |page|
    end
  end

  def redirect_back_or_default(default)
    redirect_to(session[:original_uri]|| default)
  end


  
  def find_cart
    session[:create]=true
    @cart=Cart.get_cart("cart"+session[:session_id]) rescue  Rails.cache.write("cart"+session[:session_id],{}, :expires_in => 15.minutes)
  end
  
  def empty_cart
    find_cart
    @cart.delete
    session[:cart] = nil
    find_cart
  end
    
  protected


  def authenticate
    # put an exception here for self registration
    puts "In Authenticate"
    logger.error("controller #{self.class.controller_path}")
    logger.info("action: #{action_name}")

    if(self.class.controller_path == "users" && action_name=="create")

    else
      unless User.find_by_id(session[:user_id])
        session[:original_uri] = request.request_uri
        flash[:notice] = "Please log in"
        puts("redirected to admin/login.")
        redirect_to(:controller => "registration" , :action => "login" )
      end
    end
  end

  def authorize
    # put an exception here for self registration
    if(self.class.controller_path == "users" && action_name=="create")
    else
      user =  User.find_by_id(session[:user_id])
      unless user.roles.detect{|role|
          role.rights.detect{|right|
            ((right.action == action_name)|(right.action == "*")|(right.action.include? action_name)) && right.controller == self.class.controller_path
          }
        }
        flash[:notice] = "You are not authorized to view the page you requested"
        request.env["HTTP_REFERER" ] ? (redirect_to :back) : (redirect_to "")
        return false
      end
    end
  end
  
def redis_running 
    Resque.redis_check
  end

end
