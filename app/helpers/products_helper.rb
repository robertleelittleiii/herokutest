module ProductsHelper

  def create_group_checks_live(field_name, field_pointer, value_list, tag_list_name, html_options={})
    return_value = ""
    
    value_list.each do |item|
      return_value =  return_value + "<div class='div-#{tag_list_name}'>"+ editablecheckboxtag(item, field_pointer,item,tag_list_name,html_options) +"</div>" 
    end
    return return_value.html_safe
  end


end
