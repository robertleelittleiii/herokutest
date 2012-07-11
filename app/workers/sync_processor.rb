class SyncProcessor  
  extend Resque::Plugins::Director
  direct :min_workers => 0, :max_workers => 4, :max_time => 30, :max_queue => 10, :wait_time => 1
  # @queue = :test

  @queue = :sync_queue
  def self.perform(importer_id)
    importer= Importer.find(importer_id)
 
    importer.status="Processing"
    importer.status_percent=1
    importer.stauts_message="Opening Connection..."
    importer.save 
    
    table_name=importer.table_name
        
    table_data= table_name.classify.constantize.find(:all)
    uri_command="Insert-Update"
    uri_string= importer.full_uri_path + "?" + "login=" + importer.login_id + "&" + "EncryptedPassword=" + importer.password + "&" + "Import=" + uri_command 
    uri = URI.parse(uri_string)

    http=Net::HTTP.new(uri.host,uri.port)
    path= uri.path + "?" + uri.query

    api_header="<?xml version=\"1.0\" encoding=\"utf-8\" ?> <xmldata> "  
    api_footers= "</xmldata>"
     
    record_count = table_data.count-1
   # record_count = 10
    
    row_counter = 1
    while row_counter <=record_count do
      api_from_table_name_start = "<"+importer.importer_items[0].from_table_name+">" rescue ""
      api_insert_fields = ""
      for rule in importer.importer_items
         puts(row_counter.to_s + ":" + rule.from_column + "=>" + rule.to_column_name+"("+((eval("table_data[row_counter]."+rule.to_column_name.gsub(/[.]/,'[0].')) rescue "").to_s.strip||"")+")")
        rule_value = ((eval("table_data[row_counter]."+rule.to_column_name.gsub(/[.]/,'[0].')) rescue "").to_s.strip||"")  
        puts(table_data[row_counter].inspect)
        api_insert_fields = api_insert_fields + "<" + rule.from_column + ">" + rule_value + "</" + rule.from_column + ">"
     end
      api_from_table_name_end = "</"+importer.importer_items[0].from_table_name+">" rescue ""
       
      api_data = api_header+ api_from_table_name_start+api_insert_fields+api_from_table_name_end+api_footers
      
      status_percent=Float(Float(row_counter)/Float(record_count)*100)
      importer.status="Processing File" 
      importer.status_percent=status_percent.to_i
      importer.stauts_message="Processing Record " + row_counter.to_s + " of " + record_count.to_s
      importer.save
        
      response=http.post(path, api_data)       
              
      row_counter+=1

    end 
    importer.status="Complete"
    importer.status_percent=100
    importer.stauts_message="Process Complete"
    importer.save     
  end
end