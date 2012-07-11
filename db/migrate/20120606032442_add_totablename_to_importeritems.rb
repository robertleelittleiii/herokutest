class AddTotablenameToImporteritems < ActiveRecord::Migration
  def self.up
    add_column :importer_items, :to_table_name, :string
  end

  def self.down
    remove_column :importer_items, :to_table_name
  end
end
