class AttachmentsController < ApplicationController
  skip_before_filter :verify_authenticity_token, :only => :create

  def manage
    @attachments = "tiny_#{params[:media]}".classify.constantize.order('created_at DESC').page(params[:page]).per(18)

    #@attachments = "tiny_#{params[:media]}".classify.constantize.paginate :page => params[:page], :order => 'created_at DESC', :per_page => 10
    #     respond_to do |format|
    #      format.html # index.html.erb
    #      format.json  { render :json => @attachments }
    #    end
    respond_to do |format|
      format.html {puts("FORMAT: html")}
      format.js {puts("FORMAT: js")}
      format.json {puts("FORMAT: json")}

    end
    
    render :update do |page|
      page.replace_html :dynamic_images_list, :partial => 'show_attachment_list'
    end
  end
  


  def create
    @attachment = "tiny_#{params[:media]}".classify.constantize.new params[params[:media]]
    
    if @attachment.save
      GC.start
      responds_to_parent do
        render :update do |page|
          page << "upload_callback();"
        end
      end
    else
      responds_to_parent do
        render :update do |page|
          page.alert('Sorry, there was an error uploading the photo.')
        end
      end
    end
  end
  
  def show
    #  @attachments = "tiny_#{params[:media]}".classify.constantize.paginate :page => params[:page],:params=>{}, :order => 'created_at DESC', :per_page => 10
    @attachments = "tiny_#{params[:media]}".classify.constantize.order('created_at DESC').page(params[:page]).per(18)

  end
  
  def delete
    @media = "tiny_#{params[:media]}".classify.constantize.find(params[:id])
    @media.destroy
    
    #@attachments = "tiny_#{params[:media]}".classify.constantize.paginate :page => params[:page], :order => 'created_at DESC', :per_page => 10
    @attachments = "tiny_#{params[:media]}".classify.constantize.order('created_at DESC').page(params[:page]).per(18)

    render :update do |page|
      page.replace_html :dynamic_images_list, :partial => 'show_attachment_list'
    end
    
    #redirect_to "/javascripts/tiny_mce/plugins/curblyadvimage/image.htm"
    # 
    # render :html=>":nothing=>true"
    # render :nothing => true, :status => 200, :content_type => 'text/html'
    #
    #   responds_to_parent do
    #        render :update, :layout=>false do |page|
    #            page.alert ("before")
    #             page.replace_html :dynamic_images_list, :partial => 'show_attachment_list'
    #            page.alert ("after")
    #        end
    #     end
    
    #    if (request.xhr?)
    #     render :js => "alert('Hello Rails');"
    #   else 
    #      render :nothing=>true
    #   end
  end
  
  #   def destroy
  #    @picture = "Tiny_#{params[:media]}".find(params[:id])
  #    @picture.destroy
  #
  #    respond_to do |format|
  #      format.html { redirect_to(pages_url) }
  #      format.js
  #      format.xml  { head :ok }
  #    end
  #  end

  
end
