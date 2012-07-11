class AddSkuActiveToProductDetails < ActiveRecord::Migration
  def self.up
    add_column :product_details, :sku_active, :boolean
  end

  def self.down
    remove_column :product_details, :sku_active
  end
end
