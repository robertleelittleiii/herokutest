class AddShippingAndTaxToOrders < ActiveRecord::Migration
  def self.up
    add_column :orders, :shipping_cost, :float
    add_column :orders, :sales_tax, :float
    add_column :orders, :shipping_method, :integer
  end

  def self.down
    remove_column :orders, :shipping_method
    remove_column :orders, :sales_tax
    remove_column :orders, :shipping_cost
  end
end
