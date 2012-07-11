class Importer < ActiveRecord::Base
  has_many :importer_items
  
  has_many :file_atts,  :dependent => :destroy, :order=>:position, :as=>:resource

end
