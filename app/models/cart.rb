class Cart

  attr_reader :items, :id
  
  
  def initialize(cart_id)
    @id=cart_id
    @items = []
    @visable=false
    @shipping = 0
  end

  def save
    saved_cart = self.dup
    saved_cart_items = self.items.dup
   
    Rails.cache.write(self.id, saved_cart, :expires_in => 24.hours)  
    Rails.cache.write(self.id+"items",saved_cart_items,:expires_in => 24.hours)
  end
 
  def delete
    Rails.cache.delete(self.id)
    Rails.cache.delete(self.id+"items")
  end
 
  def self.get_cart(cart_object_id)
    puts("cart initialized with id:#{cart_object_id}")
    @cart_object = Rails.cache.fetch(cart_object_id, :expires_in => 24.hours) {Cart.new(cart_object_id)}
    @cart_items  = Rails.cache.fetch(cart_object_id+"items", :expires_in => 24.hours) {[]}
   
    @cart=@cart_object.dup   
    @cart.items.replace (@cart_items.dup) 
   
   
    #   puts("Before: #{cart_object_id}")
    #   begin 
    #     @cart_object = ObjectSpace._id2ref(cart_object_id)
    #    puts("cart_object.id #{@cart_object.id}")
    #    puts("cart_object.class #{@cart_object.class == Cart}")
    #
    #     if not @cart_object.class.to_s == "Cart" then
    #       @cart_object = Cart.new
    #     end
    #   rescue
    #     @cart_object = Cart.new
    #   end
    #      puts("After: #{@cart_object.id}")

    return @cart
   
  end
 
  #  def add_product(inventory_item)
  #    @items << inventory_item
  # end

  def add_product(product, product_detail, quantity)
    
    current_item = @items.find {|item| item.product_detail.id == product_detail.id}
   

    if current_item.blank? then
      current_item = CartItem.new(product,product_detail, quantity)
      @items << current_item
    else
      current_item.increment_quantity(quantity)
      if current_item.quantity  >= product_detail.units_in_stock then
       current_item.quantity = product_detail.units_in_stock
        
      end
    end
    self.save

    return(current_item)
    
  end

  def total_items
    @items.sum { |item| item.quantity }
  end

  def total_price
    @items.sum { |item| item.price }

    #  @items.sum { |item| item.price } + (@shipping ||= 0)
    #    @items.sum { |item| item.price } + (self.calc_shipping ||= 0)

  end

  def grand_total_price
    total_price + calc_shipping[shipping_type] + calc_tax
  end
  
  def calc_tax 
    @items.sum { |item| item.tax(0.07) }
   # total_price * 0.07
  end
  
  def shipping_type
    @shipping_type || 0
  end
  
  def shipping_type=(type=0)
    @shipping_type=type
  end

  def price_in_cents
    (self.total_price*100).round
  end

  def shipping_cost
    (@shipping ||= 0)
  end

  def set_shipping(shipping_cost)
    @shipping=shipping_cost
  end

  def calc_shipping
    case total_price
    when 0..49.99
      [5,10,15,0]
    when 50..99.99
      [7,15,20,0]
    when 100..149.99
      [10,17,22,0]
    when 150..1999.99
      [0,20,25,0]
    else
      [0,0,0,0]
    end
  end


  def id=(identifier)
    @id= identifier
    save
  end

  def items=(items)
    @items.replace(items.dup)
    save
  end

  def hide
    @visable=false
  end

  def show
    @visable=true
  end

  def visable
    @visable
  end

  def standard_checkout(return_url, success_url)

    values = {
      :business => 'sales@billabongnj.com',
      :cmd => '_cart',
      :upload => 1,
      :return => success_url,
      :cancel => return_url,
      :rm => 2,
      :notify_url=>success_url,
      :handling_cart=> calc_shipping,
      :invoice => id
    }
  

    items.each_with_index do |item, index|
      values.merge!({
          "amount_#{index+1}" => item.product.price,
          "item_name_#{index+1}" => item.title,
          "item_number_#{index+1}" => item.id,
          "quantity_#{index+1}" => item.quantity
        })
    end
    "https://sandbox.paypal.com/cgi-bin/webscr?" + values.to_query
  end



end