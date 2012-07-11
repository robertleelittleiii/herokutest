class CreateOrderItems < ActiveRecord::Migration
  def self.up
    create_table :order_items do |t|
      t.integer :order_id
      t.integer :product_id
      t.integer :product_detail_id
      t.float :price
      t.integer :quantity
      t.integer :discount
      t.string :size
      t.string :color
      t.string :description
      t.string :title
      t.boolean :shipped
      t.date :shipped_date

      t.timestamps
    end
  end

  def self.down
    drop_table :order_items
  end
end
