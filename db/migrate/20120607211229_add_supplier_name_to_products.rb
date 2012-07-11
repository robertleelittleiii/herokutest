class AddSupplierNameToProducts < ActiveRecord::Migration
  def self.up
    add_column :products, :supplier_name, :string
  end

  def self.down
    remove_column :products, :supplier_name
  end
end
