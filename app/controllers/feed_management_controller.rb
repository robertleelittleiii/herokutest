
class FeedManagementController < ApplicationController
  # uses "libxml-ruby"
  # requires :xml
  
  FILESTOSHOW = 1

  def importfile
    @filestoshow=FILESTOSHOW
    @importers = Importer.find_all_by_importer_type ("file", :order=>"name desc")
    @current_importer=:null 
    
    if params[:id].blank? then
    
    
      @files = Dir.glob("public/data_import/*")
      @files = FileAtt.find_all_by_resource_type "feed_managment"
      
      @feed_manager = FeedManagement.new()
      puts("feed manager id", @feed_manager.id)
      puts("feed manager name", @feed_manager.name)
      puts("feed manager files", @feed_manager.files)
      puts("feed manager resource type", @feed_manager.resource_type)
    
      # @workbook = Excelx.new("public/data_import/Master_Surgical_List_(11-15-10).xlsx")
      # @workbook.default_sheet="Sheet1"
      #@name_row=@workbook.row(1)
      #@hashed_name_row=Hash[@name_row.collect { |v| [v, @name_row.index(v)]}]
      #@table_names=Dir.glob(RAILS_ROOT + '/app/models/*.rb').collect{|file| File.basename(file,".rb").pluralize}
      #@model_names=Dir.glob(RAILS_ROOT + '/app/models/*.rb').collect{|file| File.basename(file,".rb").classify}
      @selected_model=""
      @selected_row=""
      @selected_table=""
    
    else
      @current_importer=params[:id] 
      @importer = Importer.find(params[:id])
      @model_list=Dir.glob(RAILS_ROOT + '/app/models/*.rb')
      @model_names=@model_list.collect{|file| File.basename(file,".rb").classify}   
    end
    
  end    

  
  def columns_render_partial
    @model_name=params[:model_name]
    #   @table_columns_part = (@model_name.constantize.column_names + @model_name.constantize.reflect_on_all_associations(:has_many).collect { |each| [ each.active_record.column_names.collect { |each_field| each.name.to_s + "." + each_field }]}).flatten.sort
    @table_columns_part = (@model_name.constantize.column_names + @model_name.constantize.reflect_on_all_associations(:has_many).collect { |each| [ each.name.to_s.classify.constantize.column_names.collect { |each_field| each.name.to_s + "." + each_field rescue "" } ] rescue ""}).flatten.sort

    #    @table_columns_part = @model_name.constantize.column_names
    @table_columns = @table_columns_part.collect{|item|[item, @table_columns_part.index(item)]} 
    #  @table_columns = @model_name.constantize.column_names
      
    render :partial => "columns"
  end
  
  def importer_name_partial
    if params[:id]=="" then
      render :nothing=>true
    else
      @importer_name=params[:importer_name]
      @importer = Importer.find(params[:id])
      puts("nameofimporter:",@importer.name)
      render :partial => "importer_name"
    end 
  end
  
  def web_service_info_partial
    if params[:id].blank? then
      render :nothing=>true
    else
      @importer = Importer.find(params[:id])
      puts("nameofimporter:",@importer.name)
      render :partial => "web_services_info"
    end
  end
  
  def set_up_importer_partial
    puts("params ID",params[:id])
     
    if params[:id].blank? then
      render :nothing=>true
    else
      @importer = Importer.find(params[:id])
      @current_importer=params[:id]
      
      @importers = Importer.find(:all, :order=>"name desc")
      @importers = Importer.find_all_by_importer_type (params[:importer_type] , :order=>"name desc")

      puts("nameofimporter:",@importer.name)
      
      render :partial => "set_up_importer", :format=>"html"
    end 
  end
  
  def load_importer_progress
    puts("params ID",params[:id])
     
    if params[:id].blank? then
      render :nothing=>true
    else
      @importer = Importer.find(params[:id])
      
      render :partial => "import_progress_block", :format=>"html"
    end 
  end
  
  def import_action_partial
    if params[:id]=="" then
      render :nothing=>true
    else
      @importer = Importer.find(params[:id])
      @filestoshow=FILESTOSHOW
      @model_list=Dir.glob(RAILS_ROOT + '/app/models/*.rb')
      @model_names=@model_list.collect{|file| File.basename(file,".rb").classify}
      @table_columns = {}
      
      #      @table_columns_part = @importer.table_name.constantize.column_names rescue {}
      #      @table_columns = @table_columns_part.collect{|item|[item, @table_columns_part.index(item)]}
      #  
      #      @file_path=@importer.file_atts[0].file_info_url
      #      @pathtopublic = Rails.root.to_s + "/public"  
      #      puts("file path",@pathtopublic+@file_path)
      #      @workbook = Excelx.new(@pathtopublic+@file_path)
      #      @workbook.default_sheet="Sheet1"
      #      @name_row=@workbook.row(1)
      #      
      #      @hashed_name_row=Hash[@name_row.collect { |v| [v, @name_row.index(v)]}]
      #      puts(@hashed_name_row)
      render :partial => "import_action"
    end
  end
  
  def xsd_columns_render_partial
    if (not params[:file_path]=="") then

      @pathtopublic = Rails.root.to_s + "/public/"  
      @fullpath = @pathtopublic+params[:file_path]
      
      xml = File.open (@fullpath).read
      source=XML::Parser.string(xml)
      content = source.parse

      
      entries = content.root.find('./xs:element/xs:complexType/xs:choice/xs:element/xs:complexType/xs:sequence/xs:element')
      @table_name = entries[0].attributes["TableNameXsd"]

      @hashed_name_row = Hash[entries.collect { |each| [each.attributes["name"].camelize.gsub(/([^A-Z]+)([^A-Z])*/,"\\1\\2 ").humanize.strip, each.attributes["name"]]}].sort
      
      render :partial => "xsd_columns"
       
    else
      render :nothing=>true
    end  
    
  end
  
  
  def sheet_columns_render_partial
    if (not params[:file_path]=="") then
     
      @pathtopublic = Rails.root.to_s + "/public/"  
      @fullpath = @pathtopublic+params[:file_path]
      
      case File.extname(params[:file_path]).delete!(".")
        
      when "xls"
        @workbook = Excel.new(@fullpath)

      when "xlsx"
        @workbook = Excelx.new(@fullpath)

      when "ods"
        @workbook = Openoffice.new(@fullpath)
      end
      
      wb_info=Hash[@workbook.info.scan(/\b(.*):(.*)/)]

      @workbook.default_sheet= @workbook.sheets[0]
      @name_row=@workbook.row(1)
      @hashed_name_row=Hash[@name_row.collect { |v| [v, @name_row.index(v)]}]
      @workbook_size = "Size Cols:("+wb_info["First column"].strip+"..."+wb_info["Last column"].strip + ") by Rows:(" + wb_info["First row"].strip+"..."+wb_info["Last row"].strip+")"

      render :partial => "sheet_columns"
    else
      render :nothing=>true
    end  
  end
  
  def add_importer_item
    @importer = Importer.find(params[:id])
    @importer_item = ImporterItem.new()
      
    @importer_item.from_column=params[:from_column]
    @importer_item.to_column=params[:to_column]
    @importer_item.from_column_name=params[:from_column_name]
    @importer_item.to_column_name=params[:to_column_name]
    @importer_item.to_table_name=params[:to_table_name]
    @importer_item.from_table_name=params[:from_table_name]
    
    @importer_item.save
      
    @importer.importer_items<< @importer_item
    
    #      @file_path=@importer.file_atts[0].file_info_url
    #      
    #      @pathtopublic = Rails.root.to_s + "/public/"  
    #      puts("file path",@pathtopublic+@file_path)
    #      @workbook = Excelx.new(@pathtopublic+@file_path)
    #      @workbook.default_sheet="Sheet1"
    #      @name_row=@workbook.row(1)
    #      
    #      @hashed_name_row=Hash[@name_row.collect { |v| [v, @name_row.index(v)]}]
    #    
    #      @table_columns_part = @importer.table_name.constantize.column_names rescue {}
    #      @table_columns = @table_columns_part.collect{|item|[item, @table_columns_part.index(item)]}
    #      
    
    render :partial=>"importer_items_list"
    
  end
  
  def add_file_static
  

    format = params[:format]
    file=params[:file]
    @filestoshow = FILESTOSHOW
    puts("file: ",file)
    puts("file.size:",file.size )
    if file.size > 0 then
      @file = FileS.new(:file_att=>file)
      @file.resource_type="feed_managment"
      @file.resource_id=1
      @file.position=999
      @file.save
    end
    
    @feed_manager = FeedManagement.new()
    puts("files:", @feed_manager.files)   
    
    respond_to do |format|
      flash[:notice] = 'file was successfully added.'
      format.js do
        responds_to_parent do
          render :update do |page|
            page.replace_html("files" , :partial => "/files/files" , :object => @feed_manager.files)
            if @feed_manager.files.count >= @filestoshow
              page.hide "filebutton"
            end
            page.hide "loader_progress"
            page.show "upload-form"
            page.visual_effect :highlight, "file_#{@file.id}"
            page[:files].show if @feed_manager.files.count >= 1
            page.call "window.setupDelete"
            page.call "window.updateSheetColumns"
          end
        end
      end

      format.html { redirect_to :action => 'show', :id => params[:id] }
    end
  end

  
  def add_file
    @importer = Importer.find(params[:id])

    format = params[:format]
    file=params[:file]
    @filestoshow = FILESTOSHOW
    puts("file: ",file)
    puts("file.size:",file.size )
    if file.size > 0 then
      @file = FileAtt.new(:file_info=>file)
      @file.position=999
      @file.save
      
      @importer.file_atts<< @file

    end
    
    #  @feed_manager = FeedManagement.new()
    puts("files:", @importer.file_atts)   
    
    respond_to do |format|
      flash[:notice] = 'file was successfully added.'
      format.js do
        responds_to_parent do
          render :update do |page|
            page.replace_html("files" , :partial => "/files/files" , :object => @importer.file_atts)
            if @importer.file_atts.count >= @filestoshow
              page.hide "filebutton"
            end
            page.hide "loader_progress"
            page.show "upload-form"
            page.visual_effect :highlight, "file_#{@file.id}"
            page[:files].show if @importer.file_atts.count >= 1
            page.call "window.setupDelete"
            page.call "window.updateSheetColumns"
          end
        end
      end

      format.html { redirect_to :action => 'show', :id => params[:id] }
    end
  end

  def delete_file
    #    @menu = Menu.find(params[:incoming_id])
    @file = FileAtt.find(params[:id])
    @file.destroy
    
    #  respond_to do |format|  
    #          format.html { render :nothing => true }
    #          format.js   { render :nothing => true }  
    #  end  

    # head :deleted
    render :nothing=>true

    ##    respond_to do |format|
    #      format.js if request.xhr?
    #      format.html {redirect_to :action => 'show', :id=>params[:menu_id]}
    #    end
  end
  
  def delete_import_item
    #    @menu = Menu.find(params[:incoming_id])
    @item = ImporterItem.find(params[:id])
    @item.destroy
    
    #  respond_to do |format|  
    #          format.html { render :nothing => true }
    #          format.js   { render :nothing => true }  
    #  end  

    # head :deleted
    render :nothing=>true

    ##    respond_to do |format|
    #      format.js if request.xhr?
    #      format.html {redirect_to :action => 'show', :id=>params[:menu_id]}
    #    end
  end
  
  def delete_file_static
    #    @menu = Menu.find(params[:incoming_id])
    @file = FileS.find(params[:id])
    @file.destroy
    
    #  respond_to do |format|  
    #          format.html { render :nothing => true }
    #          format.js   { render :nothing => true }  
    #  end  

    # head :deleted
    render :nothing=>true

    ##    respond_to do |format|
    #      format.js if request.xhr?
    #      format.html {redirect_to :action => 'show', :id=>params[:menu_id]}
    #    end
  end

  #  def destroy_file
  #    @file = FileS.find(params[:id])
  #    @file.destroy
  #    redirect_to :action => 'show', :id => params[:menu_id]
  #  end

  def update_file_order
    params[:album].each_with_index do |id, position|
      #   Image.update(id, :position => position)
      Picture.reorder(id,position)
    end
    render :nothing => true

  end

  def get_sheet
   
    @workbook = Excelx.new("public/data_import/Master_Surgical_List_(11-15-10).xlsx")
    @workbook.default_sheet="Sheet1"
    @name_row=@workbook.row(1)
    @hashed_name_row=Hash[@name_row.collect { |v| [@name_row.index(v), v]}]

  end 
  
  def create_empty_record
    @importer = Importer.new
    @importer.name=Time.now.to_s
    @importer.importer_type = params[:importer_type]
    @importer.save
    @current_importer=@importer.id
    puts("importer:",@importer.id)
    #        @importer = Importer.find(params[:id])
    @model_list=Dir.glob(RAILS_ROOT + '/app/models/*.rb')
    @model_names=@model_list.collect{|file| File.basename(file,".rb").classify}  
    @importers = Importer.find_all_by_importer_type (params[:importer_type], :order=>"name desc")

    #  render :partial => "set_up_importer"

    # render :partial=>"set_up_importer"
    #  redirect_to(:action=>:importfile, :id=>@importer, :format=>"html")
    redirect_to(:action=>:set_up_importer_partial, :id=>@importer.id, :importer_type=>params[:importer_type], :format=>"html")
  end
  
  def import_sheet
    @importer= Importer.find(params[:importer_id])
    if @importer.status=="Processing" then
      # file is being processed, take no action.
      puts("Processing in progress.  Take NO ACTION!!")
    else
      puts("Starting Processing")
      @importer.status="Start"
      @importer.status_percent=0
      @importer.stauts_message="Starting Import..."
      @importer.save
    
      if @importer.importer_type=="file" then
        Resque.enqueue(ImportProcessor, @importer.id)
      else
        Resque.enqueue(SyncProcessor, @importer.id)
      end
    end
    
    render :nothing=>true
    
  end
  
  def import_sheet_OLD
    # get the importer to use by importer_id
    @importer= Importer.find(params[:importer_id])
    
    
    @pathtopublic = Rails.root.to_s + "/public"  
    @fullpath = @pathtopublic+@importer.file_atts[0].file_info_url
      
    case File.extname(@fullpath).delete!(".")
        
    when "xls"
      @workbook = Excel.new(@fullpath)

    when "xlsx"
      @workbook = Excelx.new(@fullpath)

    when "ods"
      @workbook = Openoffice.new(@fullpath)
    end
      
    wb_info=Hash[@workbook.info.scan(/\b(.*):(.*)/)]
   
    record_count = wb_info["Last row"].to_i * wb_info["Number of sheets"].to_i
    total_row_counter = 0
    
    wb_info["Sheets"].split(",").each do |sheet_name|
      #  @workbook.default_sheet="Billabong"
      row_counter = 1

      @workbook.default_sheet=sheet_name.strip()

      @name_row=@workbook.row(1)
      # How many rows to import

 
      while row_counter <=record_count do
        total_row_counter+=1
        row_counter+=1
        input_record= Hash.new()
        nilcheck=true
        @table_name=@importer.table_name
        
        input_record.merge!(@table_name=>{})
        
        for rule in @importer.importer_items
          column_count=rule.from_column.to_i+1
          nilcheck = (nilcheck and (@workbook.cell(row_counter,rule.from_column.to_i+1).nil?))
          isRelationship = rule.to_column_name.split(".")
          if (not nilcheck) then
            if isRelationship.size > 1 then
              input_record.merge!(isRelationship[0].classify=>{}) if not input_record.has_key?(isRelationship[0].classify)
              input_record[isRelationship[0].classify].merge!(Hash[isRelationship[1],@workbook.cell(row_counter,rule.from_column.to_i+1).to_s.strip.delete(160.chr+194.chr)])
            else
              input_record[@table_name].merge!(Hash[rule.to_column_name,@workbook.cell(row_counter,rule.from_column.to_i+1).to_s.strip.delete(160.chr+194.chr)])
            end
          end
        end
        # test for sheet_name attribute in object
        input_record[@table_name].merge!(Hash["sheet_name",sheet_name.strip()]) if ((not @table_name.classify.constantize.new.attributes.keys.index("sheet_name").blank?) and (not nilcheck))

        if input_record[@table_name].length > 0
          
          begin
            @item= @table_name.classify.constantize.new(input_record[@table_name])
            @item.save
            @item_id=@item.id
            puts("Item info:#{@item.inspect}")
          rescue
            @item=@table_name.classify.constantize.where(input_record[@table_name]).first
            @item_id = @item.id rescue 0
            puts("error occured")
          end
        
          
          input_record.each_pair do |item_key, item_value|
            puts("table #{item_key}, hash:#{item_value.inspect}")
            if (item_key != @table_name) then
              begin
                @sub_item= item_key.classify.constantize.new(item_value)
                puts("p:#{@table_name.tableize.singularize}_id=#{@item_id.to_s}")
                @sub_item.send("#{@table_name.tableize.singularize}_id=", @item_id)
                @sub_item.save
              rescue
                puts("error occured")
              end
            end
          end
        end

        #        if (not nilcheck) then
        #      
        #          puts(input_record.inspect)
        #
        #          @table_name=@importer.table_name
        #        
        #          begin 
        #            @item= @table_name.classify.constantize.new(input_record)
        #          
        #            @item.save
        #          rescue
        #            puts("Error: Table not found#{@table_name}")
        #          end
        #        
        #        
        #        else
        #          puts("x")
        #          puts("x")
        #          puts("x")
        #          puts("nil record, ignored")
        #        end
        #        
        puts(input_record.inspect)
      
          
 
        #  break if i == 2
      end 
    
    end 
    @hashed_name_row=Hash[@name_row.collect { |v| [v, @name_row.index(v)]}]
    render :nothing=>true
  end
  

  def webservicesync
    @filestoshow=FILESTOSHOW
    @importers = Importer.find_all_by_importer_type ("web-service" , :order=>"name desc")
    @current_importer=:null 
    
    if params[:id].blank? then
    
    
      @files = Dir.glob("public/data_import/*")
      @files = FileAtt.find_all_by_resource_type "feed_managment"
      
      @feed_manager = FeedManagement.new()
      puts("feed manager id", @feed_manager.id)
      puts("feed manager name", @feed_manager.name)
      puts("feed manager files", @feed_manager.files)
      puts("feed manager resource type", @feed_manager.resource_type)
    
      @workbook = Excelx.new("public/data_import/Master_Surgical_List_(11-15-10).xlsx")
      @workbook.default_sheet="Sheet1"
      @name_row=@workbook.row(1)
      @hashed_name_row=Hash[@name_row.collect { |v| [v, @name_row.index(v)]}]
      @table_columns = (Pricing.column_names + Product.reflect_on_all_associations(:has_many).collect { |each| [ each.active_record.column_names.collect { |each_field| each.name.to_s + "." + each_field }]}).flatten.sort
      @table_names=Dir.glob(RAILS_ROOT + '/app/models/*.rb').collect{|file| File.basename(file,".rb").pluralize}
      @model_names=Dir.glob(RAILS_ROOT + '/app/models/*.rb').collect{|file| File.basename(file,".rb").classify}
      @selected_model=""
      @selected_row=""
      @selected_table=""
    
    else
      @current_importer=params[:id] 
      @importer = Importer.find(params[:id])
      @model_list=Dir.glob(RAILS_ROOT + '/app/models/*.rb')
      @model_names=@model_list.collect{|file| File.basename(file,".rb").classify}   
    end
    
  
  end

  def generate_request
    @importer= Importer.find(params[:importer_id])
     
    @table_name=@importer.table_name
        
    @table_data= @table_name.classify.constantize.find(:all)
    uri_command="Insert-Update"
    puts(@table_data.inspect)
    uri_string= @importer.full_uri_path + "?" + "login=" + @importer.login_id + "&" + "EncryptedPassword=" + @importer.password + "&" + "Import=" + uri_command 
    uri = URI.parse (uri_string)
      
    #  uri=URI.parse('http://v833920.e3wxp2dno7n6.demo5.volusion.com/net/WebService.aspx?Login=little@mac.com&EncryptedPassword=0E0517191356E9B4977B38E3E51B1F4928014F95B31FC2AC8E75C50501E12D6C&Import=Insert')

    http=Net::HTTP.new(uri.host,uri.port)
    path= uri.path + "?" + uri.query
    # path=('/net/WebService.aspx?Login=little@mac.com&EncryptedPassword=0E0517191356E9B4977B38E3E51B1F4928014F95B31FC2AC8E75C50501E12D6C&Import=Insert')

       
      
      
      
      
    api_header="<?xml version=\"1.0\" encoding=\"utf-8\" ?> <xmldata> "  
    api_footers= "</xmldata>"
     
    record_count = @table_data.count-1
    record_count = 10
    
    row_counter = 1
    while row_counter <=record_count do
      api_from_table_name_start = "<"+@importer.importer_items[0].from_table_name+">" rescue ""
      api_insert_fields = ""
      for rule in @importer.importer_items
        puts(row_counter.to_s + ":" + rule.from_column + "=>" + rule.to_column_name+"("+((eval("@table_data[row_counter]."+rule.to_column_name.gsub(/[.]/,'[0].')) rescue "").to_s.strip||"")+")")
        rule_value = ((eval("@table_data[row_counter]."+rule.to_column_name.gsub(/[.]/,'[0].')) rescue "").to_s.strip||"")  
        puts(@table_data[row_counter].inspect)
        api_insert_fields = api_insert_fields + "<" + rule.from_column + ">" + rule_value + "</" + rule.from_column + ">"
      end
      api_from_table_name_end = "</"+@importer.importer_items[0].from_table_name+">" rescue ""
       
      api_data = api_header+ api_from_table_name_start+api_insert_fields+api_from_table_name_end+api_footers
      
        
        
      puts(api_data)
      response=http.post(path, api_data) 
      puts(response)
      #puts(input_record.inspect)
      
          
 
      #  break if i == 2
      
      row_counter+=1

    end 
    render :nothing=>true
      
  end
  
  
  def from_xml_to_database
    @importer= Importer.find(params[:importer_id])
     
    @table_name=@importer.table_name
        
    # @table_data= @table_name.classify.constantize.find(:all)
    # uri_command="Insert-Update"
    # puts(@table_data.inspect)
    # uri_string= @importer.full_uri_path + "?" + "login=" + @importer.login_id + "&" + "EncryptedPassword=" + @importer.password + "&" + "Import=" + uri_command 
    # uri = URI.parse (uri_string)
      
    #  uri=URI.parse('http://v833920.e3wxp2dno7n6.demo5.volusion.com/net/WebService.aspx?Login=little@mac.com&EncryptedPassword=0E0517191356E9B4977B38E3E51B1F4928014F95B31FC2AC8E75C50501E12D6C&Import=Insert')

    # http=Net::HTTP.new(uri.host,uri.port)
    # path= uri.path + "?" + uri.query
    # path=('/net/WebService.aspx?Login=little@mac.com&EncryptedPassword=0E0517191356E9B4977B38E3E51B1F4928014F95B31FC2AC8E75C50501E12D6C&Import=Insert')

       
      
      
      
      
    # api_header="<?xml version=\"1.0\" encoding=\"utf-8\" ?> <xmldata> "  
    # api_footers= "</xmldata>"
    
     
    pathtopublic = Rails.root.to_s + "/public/data_import" 
    fullpath = pathtopublic + "/" + "products_export.xml"
    xml = File.open (fullpath).read
    
    # uri_string= @importer.full_uri_path + "?" + "login=" + @importer.login_id + "&" + "EncryptedPassword=" + @importer.password + "&" + "Import=" + uri_command 
    uri=URI.parse('http://rmrkz.cpgnd.servertrust.com/net/WebService.aspx?Login=avenelpharmacy@gmail.com&EncryptedPassword=7E23F162AC864A0EF33E9F0D991C8077B3B4C9E8FCF6CDE8DA9F1B4ABABE6719&EDI_Name=Generic\\Products&SELECT_Columns=*')
    http=Net::HTTP.new(uri.host,uri.port)
    response=http.get(uri.path+"?"+uri.query)
    response.body
    
    source=XML::Parser.string(xml)
    content = source.parse
    entries = content.find("Products")
     
     
    theHash = Hash[test.entries.collect { |each| [each.name, each.content]}]

     
     
    record_count = @table_data.count-1
    record_count = 10
    
    row_counter = 1
    while row_counter <=record_count do
      api_from_table_name_start = "<"+@importer.importer_items[0].from_table_name+">" rescue ""
      api_insert_fields = ""
      for rule in @importer.importer_items
        puts(row_counter.to_s + ":" + rule.from_column + "=>" + rule.to_column_name+"("+((eval("@table_data[row_counter]."+rule.to_column_name.gsub(/[.]/,'[0].')) rescue "").to_s.strip||"")+")")
        rule_value = ((eval("@table_data[row_counter]."+rule.to_column_name.gsub(/[.]/,'[0].')) rescue "").to_s.strip||"")  
        puts(@table_data[row_counter].inspect)
        api_insert_fields = api_insert_fields + "<" + rule.from_column + ">" + rule_value + "</" + rule.from_column + ">"
      end
      api_from_table_name_end = "</"+@importer.importer_items[0].from_table_name+">" rescue ""
       
      api_data = api_header+ api_from_table_name_start+api_insert_fields+api_from_table_name_end+api_footers
      
        
        
      puts(api_data)
      response=http.post(path, api_data) 
      puts(response)
      #puts(input_record.inspect)
      
          
 
      #  break if i == 2
      
      row_counter+=1

    end 
    render :nothing=>true
      
  end
  
  
  
end
