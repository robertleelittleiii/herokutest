class UpdatePermissionsForProductsProductDetailsSuppliers < ActiveRecord::Migration
  def self.up
    #assign them to Admin role.
    role_admin =  Role.find_by_name('Admin')
    role_cust =  Role.find_by_name('Customer')
    role_siteowner =  Role.find_by_name('Site Owner')


    right = Right.create :name => "*Access to all products actions", :controller => "products", :action => "*"
    role_admin.rights << right
    role_siteowner.rights << right
    
    right = Right.create :name => "*Access to all supplier actions", :controller => "suppliers", :action => "*"
    role_admin.rights << right
    role_siteowner.rights << right
    
    right = Right.create :name => "*Access to all product_detail actions", :controller => "product_details", :action => "*"
    role_admin.rights << right
    role_siteowner.rights << right
    
    right = Right.create :name => "*Access to all slider actions", :controller => "sliders", :action => "*"
    role_admin.rights << right
    role_siteowner.rights << right
    
    role_siteowner.save
    role_cust.save
    role_admin.save 
  end

  def self.down
    #Destroy all rights    
    right = Right.find_by_name( "*Access to all products actions")
    right.destroy  rescue puts("products right not found.")
    
    right = Right.find_by_name( "*Access to all supplier actions")
    right.destroy  rescue puts("supplier right not found.")
    
    right = Right.find_by_name( "*Access to all product_detail actions")
    right.destroy  rescue puts("product_detail right not found.")
    
    right = Right.find_by_name( "*Access to all slider actions")
    right.destroy  rescue puts("slider right not found.")
    
  end
end
