class CreateProducts < ActiveRecord::Migration
  def self.up
    create_table :products do |t|
      t.integer :product_id
      t.string :sku
      t.string :supplier_product_id
      t.string :product_name
      t.text :product_description
      t.integer :supplier_id
      t.integer :department_id
      t.integer :category_id
      t.integer :quantity_per_unit
      t.string :unit_size
      t.decimal :unit_price, :precision => 8, :scale => 2
      t.decimal :msrp, :precision => 8, :scale => 2
      t.integer :product_detail_id
      t.decimal :discount
      t.float :unit_weight
      t.integer :reorder_level
      t.boolean :product_active
      t.boolean :discount_available
      t.integer :product_ranking

      t.timestamps
    end
  end

  def self.down
    drop_table :products
  end
end
