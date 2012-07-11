class ImportProcessor  
  extend Resque::Plugins::Director
  direct :min_workers => 0, :max_workers => 4, :max_time => 30, :max_queue => 10, :wait_time => 1
  # @queue = :test

  @queue = :import_queue
  def self.perform(importer_id)
    importer= Importer.find(importer_id)

    pathtopublic = Rails.root.to_s + "/public" 
    fullpath = pathtopublic+importer.file_atts[0].file_info_url
    importer.status="Start"
    importer.status_percent=1
    importer.stauts_message="Opening File..."
    importer.save 
    
    case File.extname(fullpath).delete!(".")
        
    when "xls"
      workbook = Excel.new(fullpath)

    when "xlsx"
      workbook = Excelx.new(fullpath)

    when "ods"
      workbook = Openoffice.new(fullpath)
    end
      
    wb_info=Hash[workbook.info.scan(/\b(.*):(.*)/)]
   
    record_count = wb_info["Last row"].to_i * wb_info["Number of sheets"].to_i
    total_row_counter = 0
    
    wb_info["Sheets"].split(",").each_with_index do |sheet_name, index|
      total_row_counter = wb_info["Last row"].to_i * index

      row_counter = 1

      workbook.default_sheet=sheet_name.strip()

      name_row=workbook.row(1)
      # How many rows to import


    
      while row_counter <=record_count do
        row_counter+=1
        input_record= Hash.new()
        nilcheck=true
        table_name=importer.table_name
        input_record.merge!(table_name=>{})

        for rule in importer.importer_items
          from_column = rule.from_column.to_i+1
          nilcheck = (nilcheck and (workbook.cell(row_counter,rule.from_column.to_i+1).nil?))
          isRelationship = rule.to_column_name.split(".")
          if (not nilcheck) then
            if isRelationship.size > 1 then
              input_record.merge!(isRelationship[0].classify=>{}) if not input_record.has_key?(isRelationship[0].classify)
              input_record[isRelationship[0].classify].merge!(Hash[isRelationship[1],workbook.cell(row_counter,rule.from_column.to_i+1).to_s.strip.delete(160.chr+194.chr)])
            else
              input_record[table_name].merge!(Hash[rule.to_column_name,workbook.cell(row_counter,rule.from_column.to_i+1).to_s.strip.delete(160.chr+194.chr)])
            end
          end       
        end
        
        # test for sheet_name attribute in object
        input_record[table_name].merge!(Hash["sheet_name",sheet_name.strip()]) if ((not table_name.classify.constantize.new.attributes.keys.index("sheet_name").blank?) and (not nilcheck))

        if input_record[table_name].length > 0
          
          begin
            item= table_name.classify.constantize.new(input_record[table_name])
            item.save
            
            total_row_counter += 1

            status_percent=Float(Float(total_row_counter)/Float(record_count)*100)
            importer.status="Processing File" 
            importer.status_percent=status_percent.to_i
            importer.stauts_message="Processing Record " + total_row_counter.to_s + " of " + record_count.to_s
            importer.save
            
            
            item_id=item.id
            puts("Item info:#{item.inspect}")
          rescue
            item=table_name.classify.constantize.where(input_record[table_name]).first
            item_id = item.id rescue 0
            puts("error occured")
          end
        
          
          input_record.each_pair do |item_key, item_value|
            puts("table #{item_key}, hash:#{item_value.inspect}")
            if (item_key != table_name) then
              begin
                sub_item= item_key.classify.constantize.new(item_value)
                puts("p:#{table_name.tableize.singularize}_id=#{item_id.to_s}")
                sub_item.send("#{table_name.tableize.singularize}_id=", item_id)
                sub_item.save
              rescue
                puts("error occured")
              end
            end
          end
        end

        #        if (not nilcheck) then
        #
        #          table_name=importer.table_name
        #        
        #          item= table_name.classify.constantize.new(input_record)
        #        
        #          item.save
        #          status_percent=Float(Float(total_row_counter)/Float(record_count)*100)
        #          importer.status="Processing File" 
        #          importer.status_percent=status_percent.to_i
        #          importer.stauts_message="Processing Record " + total_row_counter.to_s + " of " + record_count.to_s
        #          importer.save
        #        end
      
      
      end  
    
    end rescue importer_failed = true
    
    
    importer.status="Complete"
    importer.status_percent=100
    importer.stauts_message= (importer_failed ? "Importer Failed" : "Process Complete")
    importer.save
    
  end 
end
