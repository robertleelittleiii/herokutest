class CreateFileAtts < ActiveRecord::Migration
  def self.up
    create_table :file_atts do |t|
      t.string :name
      t.text :description
      t.integer :position
      t.string :file_info
      t.integer :resource_id
      t.string :resource_type

      t.timestamps
    end
  end

  def self.down
    drop_table :file_atts
  end
end
