# To change this template, choose Tools | Templates
# and open the template in the editor.

ActionMailer::Base.delivery_method = :smtp
ActionMailer::Base.raise_delivery_errors = true
ActionMailer::Base.smtp_settings = {
  :address => "mail.billabongnj.com",
  :port => "25",
  :domain => "billabongnj.com",
  :authentication => :login,
  :user_name => "admin@billabongnj.com",
  :password => "billabong1234",
  :enable_starttls_auto => true,
   :openssl_verify_mode => OpenSSL::SSL::VERIFY_NONE,
}
ActionMailer::Base.default_url_options[:host] = "billabongnj.com"
