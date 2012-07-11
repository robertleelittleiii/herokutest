class AddIndexesToProducts < ActiveRecord::Migration
  def self.up
    add_index :products, :product_active
    add_index :products, :created_at
    add_index :products, :product_ranking
    add_index :products, [:product_active, :created_at, :product_ranking], :name=>"cat_search_1"
  end

  def self.down
    remove_index :products, :product_active
    remove_index :products, :created_at
    remove_index :products, :product_ranking
    remove_index :products, :name=>"cat_search_1"

  end
end
