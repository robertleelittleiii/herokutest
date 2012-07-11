class AddStatusFieldsToImporter < ActiveRecord::Migration
  def self.up
    add_column :importers, :status, :string
    add_column :importers, :status_percent, :integer
    add_column :importers, :stauts_message, :text
  end

  def self.down
    remove_column :importers, :stauts_message
    remove_column :importers, :status_percent
    remove_column :importers, :status
  end
end
