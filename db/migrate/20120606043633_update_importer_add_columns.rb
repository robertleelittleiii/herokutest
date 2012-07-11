class UpdateImporterAddColumns < ActiveRecord::Migration
  def self.up
    add_column :importers, :importer_type, :string
    add_column :importers, :login_id, :string
    add_column :importers, :password, :string
    rename_column :importers, :full_file_name, :full_uri_path
  end

  def self.down
    remove_column :importers, :importer_type
    remove_column :importers, :login_id
    remove_column :importers, :password
    rename_column :importers,  :full_uri_path, :full_file_name
  end
end
