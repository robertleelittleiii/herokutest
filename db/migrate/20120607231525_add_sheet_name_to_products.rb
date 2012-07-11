class AddSheetNameToProducts < ActiveRecord::Migration
  def self.up
    add_column :products, :sheet_name, :string
  end

  def self.down
    remove_column :products, :sheet_name
  end
end
