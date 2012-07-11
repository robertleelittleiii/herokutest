class CreateImporters < ActiveRecord::Migration
  def self.up
    create_table :importers do |t|
      t.string :name
      t.string :full_file_name
      t.text :columns
      t.string :table_name

      t.timestamps
    end
  end

  def self.down
    drop_table :importers
  end
end
