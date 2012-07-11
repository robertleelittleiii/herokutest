class UserNotifier < ActionMailer::Base
  default :from=>"admin@billabongnj.com"

  
  def signup_notification(user, siteurl)
    @hostfull=siteurl
    setup_email(user)
    subject 'Please activate your new account'
    body(:user=>user, :hostfull=>@hostfull)
    content_type "text/html"   #Here's where the magic happens

    #@body  = siteurl.gsub(%r{</?[^>]+?>}, '')+"activate/#{user.activation_code}"
  end
  
  def inventory_alert(product_detail, host)
    @hostfull=host
     attachments.inline['billabong-logo-nj-wide-100.png'] = File.read('public/images/site/billabong-logo-nj-wide-100.png')
     
    @host = host
    @user = Settings.inventory_email
    @product_detail = ProductDetail.find(product_detail.id)
    
    mail(:to=>@user, :subject=>"Inventory Warning for #{@product_detail.inventory_key}")
    
  end
  
  def reservation_notification(user,product, host )
    @user = user
    @product = product
    @host = host
    
    mail(:to => "#{user.user_attribute.first_name} #{user.user_attribute.last_name}<#{user.name}>", :subject => "Item Reserved for Pickup")

  end
  
  def winner_notification(user, product, host)
    
    @user = user
    @product = product
    @host = host
    
    mail(:to => "#{user.user_attribute.first_name} #{user.user_attribute.last_name}<#{user.name}>", :subject => "Item has been given to you!!")

  end
  
  def looser_notification(user, product, host)
    
    @user = user
    @product = product
    @host = host
    
    mail(:to => "#{user.user_attribute.first_name} #{user.user_attribute.last_name}<#{user.name}>", :subject => "Sorry, you didn't get the item.")

  end
  
    
  def reservation_request_notification(user,to_user,product, host )
    @user = user
    @product = product
    @to_user = to_user
    @host = host
    
    mail(:to => "#{user.user_attribute.first_name} #{user.user_attribute.last_name}<#{user.name}>", :subject => "Item Requested for Pickup")

  end

  
  def signup_notification(user, host)
    attachments.inline['billabong-logo-nj-wide-100.png'] = File.read('public/images/site/billabong-logo-nj-wide-100.png')

    @user=user
    @hostfull=host
    
    mail(:to => "#{user.user_attribute.first_name} #{user.user_attribute.last_name}<#{user.name}>", :subject => "Welcome to Billabong NJ!!")
  end
 
  
  def reset_notification(user, host)
    
    attachments.inline['billabong-logo-nj-wide-100.png'] = File.read('public/images/site/billabong-logo-nj-wide-100.png')

    @user=user
    @hostfull=host
    
    mail(:to => "#{user.user_attribute.first_name} #{user.user_attribute.last_name}<#{user.name}>", :subject => "Reset your password")
  end
 
  
  def signup_notification2(user, siteurl)
    @hostfull=siteurl
    setup_email(user)
    subject 'Please activate your new account'
    body(:user=>user, :hostfull=>@hostfull)
    content_type "text/html"   #Here's where the magic happens

    #@body  = siteurl.gsub(%r{</?[^>]+?>}, '')+"activate/#{user.activation_code}"
  end

  def activation(user)
    setup_email(user)
    @subject    += 'Your account has been activated!'
    @body  = "http://www.BillabongNJ.com"
  end

  def reset_notification2(user, siteurl)
    @hostfull=siteurl
    setup_email(user)
    subject 'Link to reset your password'
    #    @body  = siteurl.gsub(%r{</?[^>]+?>}, '')+"reset/#{user.password_reset_code}"
    body(:user=>user, :hostfull=>@hostfull)
    content_type "text/html"   #Here's where the magic happens

  end
  
  def lostwithemail(user, host)
    attachments.inline['billabong-logo-nj-wide-100.png'] = File.read('public/images/site/billabong-logo-nj-wide-100.png')

    @user=user
    @hostfull=host
    
    mail(:to => "#{user.user_attribute.first_name} #{user.user_attribute.last_name}<#{user.name}>", :subject => "Reset Activation for BillabongNJ.com!!")
  end
  
  def shipment_notification(order, user, message, host)
    @hostfull=host
    setup_email(user)
    subject 'Your shipment has been sent'
    body (:order=>order, :user => user, :url_base => 'http://locathost:3000/grants/show')
    content_type "text/html"   #Here's where the magic happens
  end


  def order_notification(order, user, message, host)
    @hostfull=host
    setup_email(user)
    subject 'Thank you for your order'
    body (:order=>order, :user => user)
    content_type "text/html"   #Here's where the magic happens
  end

  #def winner_notification(user, message, host)
  #  @hostfull=host
  #  self.setup_email(user)
  #  subject 'Congratulations!! You are a winner.'
  #  body (:user=>user)
  #  content_type "text/html"
  #  
  #end


  
  protected

  def setup_email(user)
    @recipients  = "#{user.name}"
    @from        = "admin@billabongnj.com"
    @subject     = "[mysite]"
    @sent_on     = Time.now
    @body = user.name
  end
end