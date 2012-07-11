class AddIndexsToProductAndProductDetail < ActiveRecord::Migration
  def self.up
        add_index :products, :supplier_product_id, :unique => true
        add_index :product_details, :inventory_key, :unique => true
  end

  def self.down
        remove_index :products, :supplier_product_id
        remove_index :product_details, :inventory_key
  end
end
