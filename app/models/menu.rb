class Menu < ActiveRecord::Base
  has_many :menus, :foreign_key => :parent_id, :order => "m_order ASC", :dependent => :destroy
  has_many :pictures,  :dependent => :destroy, :order=>:position, :as=>:resource

  belongs_to :menu,  :foreign_key => :parent_id
  
  belongs_to :page
  
  # has_one :page

  def self.find_root_menus()
    find(:all, :conditions => [ "parent_id = 0"])
  end

  def self.find_menus_by_parent_id(parent_id)
    today = Time.now
    find(:all, :conditions => [ "parent_id = (?)", parent_id])
  end

     def self.find_menu(parent_id)
    find(:all, :conditions => ["parent_id = (?)", parent_id]   ,:order => "m_order ASC")
    end
end
