class Picture < ActiveRecord::Base

  
  belongs_to :menues, :polymorphic => true
  belongs_to :products, :polymorphic => true
  
  mount_uploader :image, ImageUploader

  
  def self.reorder(id,position)
    puts(id, position)
    ActiveRecord::Base.connection.execute ("UPDATE `pictures` SET `position` = '"+position.to_s+"' WHERE `pictures`.`id` ="+id.to_s+" LIMIT 1 ;")
  end
  
end
