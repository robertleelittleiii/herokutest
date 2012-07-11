class Product < ActiveRecord::Base
  has_many :product_details
  belongs_to :supplier
  has_many :pictures,  :dependent => :destroy, :order=>:position, :as=>:resource
  has_one :order_item
  
   acts_as_taggable_on :category, :department
   
  
  
end
