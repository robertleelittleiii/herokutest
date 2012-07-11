class MailerController < ApplicationController
  
      protect_from_forgery :except => :simple_form

 
  def simple_form
    @subject= params["subject"]
    @from= params["email"]
    @to= params["address_to"]
    @redirect = params["redirect"]
    
    body_field = params.clone
    body_field.delete("authenticity_token")
    body_field.delete("Submit")
    body_field.delete("from_address")
    body_field.delete("to_address")
    body_field.delete("subject")
    body_field.delete("action")
    body_field.delete("redirect")
    

    puts("Body field",body_field.to_yaml.to_s)
    @message_body = body_field.to_yaml
    puts("here", @messsage_body, @from, @to, @subject)
    @mail_item = ContactUs.send_mail(@message_body, @from, @to, @subject)
    @mail_item.deliver
    
    redirect_to @redirect
 #
 #   
 #         render :nothing=>true;
  end
  protected

  def authorize
  end

   def authenticate
  end
end
