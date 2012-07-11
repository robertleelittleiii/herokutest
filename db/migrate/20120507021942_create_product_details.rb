class CreateProductDetails < ActiveRecord::Migration
  def self.up
    create_table :product_details do |t|
      t.integer :product_id
      t.string :inventory_key
      t.string :size
      t.string :color
      t.integer :units_in_stock
      t.integer :units_on_order

      t.timestamps
    end
  end

  def self.down
    drop_table :product_details
  end
end
