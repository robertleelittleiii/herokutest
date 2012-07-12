class FeedManagement
  
  attr_accessor :name
  attr_accessor :id 
 attr_accessor :files
  attr_accessor :resource_type
  
  def self.find(param={})
    return @id
  end

  def initialize(attributes = {})
    @id=1
    @name="feed_management"
    @resource_type="feed_management"
   @files = FileAtt.find_all_by_resource_type("feed_managment")
  end
 
#  def files()
#    @files=FileS.find_all_by_resource_type "feed_managment"
#    return @files
#  end
  
  
  def set_new_file(input)
    file=FileAtt.find(input.id)
    file.resource_type = "feed_management"
    file.save
  end
end