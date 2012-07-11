class UpdatePermissionsImporterItems < ActiveRecord::Migration
  def self.up
    #assign them to Admin role.
    role_admin =  Role.find_by_name('Admin')
    role_cust =  Role.find_by_name('Customer')
    role_siteowner =  Role.find_by_name('Site Owner')

    right = Right.create :name => "*Access to all Importers actions", :controller => "importers", :action => "*"
    role_admin.rights << right
    role_siteowner.rights << right
    
     right = Right.create :name => "*Access to all Importer Items actions", :controller => "importer_items", :action => "*"
    role_admin.rights << right
    role_siteowner.rights << right
    
    role_siteowner.save
    role_cust.save
    role_admin.save 
  end

  def self.down
    #Destroy all rights    
    right = Right.find_by_name( "*Access to all Importers actions")
    right.destroy  rescue puts("order feed_management not found.")
 
    right = Right.find_by_name( "Access to all Importer Items actions")
    right.destroy  rescue puts("order feed_management not found.")
    
  end
end
