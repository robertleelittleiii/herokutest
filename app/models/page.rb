class Page < ActiveRecord::Base
#  belongs_to :menu
  has_one :menu
  has_many :sliders , :order=>:slider_order
  
  
  
  def name()
   return_name =   self.menu.nil? ? self.title : self.menu.name
   return return_name
  end
end
