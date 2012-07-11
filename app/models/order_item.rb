class OrderItem < ActiveRecord::Base
  
  belongs_to :order
  belongs_to :product
  belongs_to :product_detail
  
  
  def self.from_cart_item(cart_item)
    oi = self.new
    oi.product_id     = cart_item.product.id
    oi.product_detail_id = cart_item.product_detail.id
    oi.quantity    = cart_item.quantity
    oi.price = cart_item.price
    oi.color = cart_item.color
    oi.size = cart_item.size
    oi.title = cart_item.title
    oi.description =cart_item.description
    oi
  end
end
