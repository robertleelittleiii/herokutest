class ProductDetail < ActiveRecord::Base
  belongs_to :product

  #has_one :order_item

  
  
  def swatch
    self.product.pictures.where(:title=>self.color).first.image_url(:swatch).to_s rescue "/images/site/blank.png"
  end
  
  def thumb
    self.product.pictures.where(:title=>self.color).first.image_url(:thumb).to_s rescue "/images/site/blank.png"

  end

  def medium
    self.product.pictures.where(:title=>self.color).first.image_url(:medium).to_s rescue "/images/site/blank.png"

  end
  
  def small
    self.product.pictures.where(:title=>self.color).first.image_url(:small).to_s rescue "/images/site/blank.png"

  end
  
  def reduce_inventory (sold_count, host) 
    self.units_in_stock = self.units_in_stock - sold_count
    if self.units_in_stock.to_i < self.product.reorder_level.to_i then
          UserNotifier.inventory_alert(self, host).deliver
    end
    self.save
  end
end
