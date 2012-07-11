class CreateOrders < ActiveRecord::Migration
  def self.up
    create_table :orders do |t|
      t.integer :user_id
      t.string :credit_card_type
      t.date :credit_card_expires
      t.string :ip_address
      t.boolean :shipped
      t.date :shipped_date

      t.string :ship_first_name
      t.string :ship_last_name
      t.string :ship_street_1
      t.string :ship_street_2
      t.string :ship_city
      t.string :ship_state
      t.string :ship_zip
      
      t.string :bill_first_name
      t.string :bill_last_name
      t.string :bill_street_1
      t.string :bill_street_2
      t.string :bill_city
      t.string :bill_state
      t.string :bill_zip     
      
      t.timestamps
    end
  end

  def self.down
    drop_table :orders
  end
end
