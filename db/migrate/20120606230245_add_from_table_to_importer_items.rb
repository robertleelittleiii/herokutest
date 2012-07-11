class AddFromTableToImporterItems < ActiveRecord::Migration
  def self.up
    add_column :importer_items, :from_table_name, :string
  end

  def self.down
    remove_column :importer_items, :from_table_name
  end
end
