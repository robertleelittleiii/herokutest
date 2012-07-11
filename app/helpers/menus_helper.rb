module MenusHelper

        def menu_delete(menu)
        user =  User.find_by_id(session[:user_id])

        puts(user.name, user.roles.find_by_name("Admin"), menu.parent_id)
        returnval=""
        if (not user.roles.find_by_name("Admin").nil?)
          returnval = link_to(image_tag("interface/Button-Delete.png", :border=>"0") , menu, :class=>"delete_menu",  :confirm => 'Are you sure?', :method => :delete , :remote=>true)
        else
          if menu.parent_id==0

          else
          returnval = link_to(image_tag("interface/Button-Delete.png", :border=>"0") , menu, :class=>"delete_menu",  :confirm => 'Are you sure?', :method => :delete , :remote=>true)
          end
          
        end
         return returnval
      end

end
