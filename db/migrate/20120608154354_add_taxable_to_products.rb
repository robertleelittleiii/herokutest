class AddTaxableToProducts < ActiveRecord::Migration
  def self.up
    add_column :products, :is_taxable, :boolean
  end

  def self.down
    remove_column :products, :is_taxable
  end
end
