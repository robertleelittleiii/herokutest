# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20120608154354) do

  create_table "file_atts", :force => true do |t|
    t.string   "name"
    t.text     "description"
    t.integer  "position"
    t.string   "file_info"
    t.integer  "resource_id"
    t.string   "resource_type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "importer_items", :force => true do |t|
    t.integer  "importer_id"
    t.integer  "from_column"
    t.string   "from_column_name"
    t.integer  "to_column"
    t.string   "to_column_name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "to_table_name"
    t.string   "from_table_name"
  end

  create_table "importers", :force => true do |t|
    t.string   "name"
    t.string   "full_uri_path"
    t.text     "columns"
    t.string   "table_name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "importer_type"
    t.string   "login_id"
    t.string   "password"
    t.string   "status"
    t.integer  "status_percent"
    t.text     "stauts_message"
  end

  create_table "menus", :force => true do |t|
    t.string   "name"
    t.integer  "page_id"
    t.integer  "parent_id"
    t.boolean  "has_submenu"
    t.integer  "m_order"
    t.string   "m_type"
    t.text     "rawhtml"
    t.string   "url"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "has_image"
  end

  create_table "order_items", :force => true do |t|
    t.integer  "order_id"
    t.integer  "product_id"
    t.integer  "product_detail_id"
    t.float    "price"
    t.integer  "quantity"
    t.integer  "discount"
    t.string   "size"
    t.string   "color"
    t.string   "description"
    t.string   "title"
    t.boolean  "shipped"
    t.date     "shipped_date"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "order_transactions", :force => true do |t|
    t.integer  "order_id"
    t.string   "action"
    t.integer  "amount"
    t.boolean  "success"
    t.string   "authorization"
    t.string   "message"
    t.text     "params"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "orders", :force => true do |t|
    t.integer  "user_id"
    t.string   "credit_card_type"
    t.date     "credit_card_expires"
    t.string   "ip_address"
    t.boolean  "shipped"
    t.date     "shipped_date"
    t.string   "ship_first_name"
    t.string   "ship_last_name"
    t.string   "ship_street_1"
    t.string   "ship_street_2"
    t.string   "ship_city"
    t.string   "ship_state"
    t.string   "ship_zip"
    t.string   "bill_first_name"
    t.string   "bill_last_name"
    t.string   "bill_street_1"
    t.string   "bill_street_2"
    t.string   "bill_city"
    t.string   "bill_state"
    t.string   "bill_zip"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.float    "shipping_cost"
    t.float    "sales_tax"
    t.integer  "shipping_method"
  end

  create_table "pages", :force => true do |t|
    t.string   "title"
    t.text     "body"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "in_menu"
    t.string   "menu_local"
    t.boolean  "full_screen"
    t.boolean  "has_slider"
    t.integer  "slider_height"
    t.integer  "slider_width"
  end

  create_table "pictures", :force => true do |t|
    t.string   "title"
    t.text     "description"
    t.integer  "position"
    t.string   "image"
    t.integer  "resource_id"
    t.string   "resource_type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "product_details", :force => true do |t|
    t.integer  "product_id"
    t.string   "inventory_key"
    t.string   "size"
    t.string   "color"
    t.integer  "units_in_stock"
    t.integer  "units_on_order"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "sku_active"
  end

  add_index "product_details", ["inventory_key"], :name => "index_product_details_on_inventory_key", :unique => true
  add_index "product_details", ["inventory_key"], :name => "inventory_key", :unique => true

  create_table "products", :force => true do |t|
    t.integer  "product_id"
    t.string   "sku"
    t.string   "supplier_product_id"
    t.string   "product_name"
    t.text     "product_description"
    t.integer  "supplier_id"
    t.integer  "department_id"
    t.integer  "category_id"
    t.integer  "quantity_per_unit"
    t.string   "unit_size"
    t.decimal  "unit_price",          :precision => 8,  :scale => 2
    t.decimal  "msrp",                :precision => 8,  :scale => 2
    t.integer  "product_detail_id"
    t.decimal  "discount",            :precision => 10, :scale => 0
    t.float    "unit_weight"
    t.integer  "reorder_level"
    t.boolean  "product_active"
    t.boolean  "discount_available"
    t.integer  "product_ranking"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "supplier_name"
    t.string   "sheet_name"
    t.boolean  "is_taxable"
  end

  add_index "products", ["created_at"], :name => "index_products_on_created_at"
  add_index "products", ["product_active", "created_at", "product_ranking"], :name => "cat_search_1"
  add_index "products", ["product_active"], :name => "index_products_on_product_active"
  add_index "products", ["product_ranking"], :name => "index_products_on_product_ranking"
  add_index "products", ["supplier_product_id"], :name => "index_products_on_supplier_product_id", :unique => true

  create_table "rights", :force => true do |t|
    t.string "name"
    t.string "controller"
    t.string "action"
  end

  create_table "rights_roles", :id => false, :force => true do |t|
    t.integer "right_id"
    t.integer "role_id"
  end

  create_table "roles", :force => true do |t|
    t.string "name"
  end

  create_table "roles_users", :id => false, :force => true do |t|
    t.integer "role_id"
    t.integer "user_id"
  end

  create_table "settings", :force => true do |t|
    t.string   "var",                       :null => false
    t.text     "value"
    t.integer  "target_id"
    t.string   "target_type", :limit => 30
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "settings", ["target_type", "target_id", "var"], :name => "index_settings_on_target_type_and_target_id_and_var", :unique => true

  create_table "sliders", :force => true do |t|
    t.integer  "page_id"
    t.integer  "slider_order"
    t.string   "slider_name"
    t.boolean  "slider_active"
    t.integer  "slider_type"
    t.text     "slider_content"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "suppliers", :force => true do |t|
    t.string   "supplier_name"
    t.string   "contact_name"
    t.string   "address_1"
    t.string   "address_2"
    t.string   "city"
    t.string   "state"
    t.string   "zip_code"
    t.string   "country"
    t.string   "phone_number"
    t.string   "fax_number"
    t.string   "email_address"
    t.string   "web_site"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "taggings", :force => true do |t|
    t.integer  "tag_id"
    t.integer  "taggable_id"
    t.string   "taggable_type"
    t.integer  "tagger_id"
    t.string   "tagger_type"
    t.string   "context",       :limit => 128
    t.datetime "created_at"
  end

  add_index "taggings", ["tag_id"], :name => "index_taggings_on_tag_id"
  add_index "taggings", ["taggable_id", "taggable_type", "context"], :name => "index_taggings_on_taggable_id_and_taggable_type_and_context"

  create_table "tags", :force => true do |t|
    t.string "name"
  end

  create_table "tiny_prints", :force => true do |t|
    t.string   "image_file_name"
    t.string   "image_file_size"
    t.string   "image_content_type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "tiny_videos", :force => true do |t|
    t.string   "original_file_name"
    t.string   "original_file_size"
    t.string   "original_content_type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "user_attributes", :force => true do |t|
    t.string   "first_name"
    t.string   "last_name"
    t.string   "handle"
    t.date     "birthdate"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", :force => true do |t|
    t.string   "name"
    t.string   "hashed_password"
    t.string   "salt"
    t.string   "remember_token"
    t.datetime "remember_token_expires_at"
    t.string   "activation_code",           :limit => 40
    t.datetime "activated_at"
    t.string   "state",                                   :default => "passive"
    t.datetime "deleted_at"
    t.string   "password_reset_code",       :limit => 40
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
