class Order < ActiveRecord::Base
  belongs_to :user
  has_many :order_items , :dependent => :destroy

  has_many :transactions, :class_name => "OrderTransaction"

  attr_accessor :cc_number, :cc_verification
 
  validates_presence_of :ship_first_name, :ship_last_name, :ship_street_1, :ship_city, :ship_state, :ship_zip,
    :bill_first_name, :bill_last_name, :bill_street_1, :bill_city, :bill_state, :bill_zip,
    :credit_card_type, :cc_number, :cc_expires, :cc_verification
  
  validate_on_create :validate_card

  
  composed_of :cc_expires, :class_name => "DateTime",
    :mapping => %w(Time to_s),
    :constructor => Proc.new { |item| item },
    :converter => Proc.new { |item| item }

  CC_TYPES =  [
    ["Visa", "visa"],
    ["MasterCard", "master"],
    ["Discover", "discover"],
    ["American Express", "american_express"]
  ].freeze
  
  CC_STATES= [
    [ "Alabama", "AL" ],
    [ "Alaska", "AK" ],
    [ "Arizona", "AZ" ],
    [ "Arkansas", "AR" ],
    [ "California", "CA" ],
    [ "Colorado", "CO" ],
    [ "Connecticut", "CT" ],
    [ "Delaware", "DE" ],
    [ "Florida", "FL" ],
    [ "Georgia", "GA" ],
    [ "Hawaii", "HI" ],
    [ "Idaho", "ID" ],
    [ "Illinois", "IL" ],
    [ "Indiana", "IN" ],
    [ "Iowa", "IA" ],
    [ "Kansas", "KS" ],
    [ "Kentucky", "KY" ],
    [ "Louisiana", "LA" ],
    [ "Maine", "ME" ],
    [ "Maryland", "MD" ],
    [ "Massachusetts", "MA" ],
    [ "Michigan", "MI" ],
    [ "Minnesota", "MN" ],
    [ "Mississippi", "MS" ],
    [ "Missouri", "MO" ],
    [ "Montana", "MT" ],
    [ "Nebraska", "NE" ],
    [ "Nevada", "NV" ],
    [ "New Hampshire", "NH" ],
    [ "New Jersey", "NJ" ],
    [ "New Mexico", "NM" ],
    [ "New York", "NY" ],
    [ "North Carolina", "NC" ],
    [ "North Dakota", "ND" ],
    [ "Ohio", "OH" ],
    [ "Oklahoma", "OK" ],
    [ "Oregon", "OR" ],
    [ "Pennsylvania", "PA" ],
    [ "Rhode Island", "RI" ],
    [ "South Carolina", "SC" ],
    [ "South Dakota", "SD" ],
    [ "Tennessee", "TN" ],
    [ "Texas", "TX" ],
    [ "Utah", "UT" ],
    [ "Vermont", "VT" ],
    [ "Virginia", "VA" ],
    [ "Washington", "WA" ],
    [ "West Virginia", "WV" ],
    [ "Wisconsin", "WI" ],
    [ "Wyoming", "WY" ]
  ].freeze
    
    
    
    
 
  
  
  def generate_order_items(cart)
    cart.items.each do |item|
      li = LineItem.from_cart_item(item)

    end
  
  end


  
  def add_line_items_from_cart(cart, host)
    cart.items.each do |item|
      li = OrderItem.from_cart_item(item)
      if not li.product_detail.nil? then
        li.product_detail.reduce_inventory(item.quantity, host)
      end
      order_items << li
    end
  
    #  self.shipping_price= cart.shipping_cost
  end

  
  
  def purchase(cart)
    @cart=cart
    response = GATEWAY.purchase(price_in_cents(@cart), credit_card, purchase_options)
    transactions.create!(:action => "purchase", :amount => price_in_cents(@cart), :response => response)
    if not response.success? then
      errors.add_to_base(response.message)
    end
   
    # cart.update_attribute(:purchased_at, Time.now) if response.success?
    response.success?
  end
  
  def price_in_cents(cart)
    (cart.total_price*100).round
  end

  
  def full_shipping_name
    ship_first_name + " " + ship_last_name
  end
  
  def full_billing_name
    bill_first_name + " " + bill_last_name
  end
  
    def full_shipping_street
    ship_street_1 + " " + ship_street_2
  end
  
  def full_billing_street
    bill_street_1 + " " + bill_street_2
  end
  
  
  def total_price
     order_items.sum(:price)
  end
  
  def grand_total_price
    (total_price || 0) + (sales_tax || 0) + (shipping_cost || 0)
  end
  
  private
  
  def purchase_options
    {
      :ip => ip_address,
      :billing_address => {
        :name     => bill_first_name + " " + bill_last_name,
        :address1 => bill_street_1 + " " + bill_street_2,
        :city     => bill_city,
        :state    => bill_state,
        :country  => "US",
        :zip      => bill_zip
      },
      :shipping_address => {
        :name     => ship_first_name + " " + ship_last_name,
        :address1 => ship_street_1 + " " + ship_street_2,
        :city     => ship_city,
        :state    => ship_state,
        :country  => "US",
        :zip      => ship_zip
      }
    }
  end
  
  def validate_card
    unless credit_card.valid?
      credit_card.errors.full_messages.each do |message|
        errors.add_to_base message
      end
    end
  end
  
  def credit_card
    @credit_card ||= ActiveMerchant::Billing::CreditCard.new(
      :type               => credit_card_type,
      :number             => cc_number,
      :verification_value => cc_verification,
      :month              => cc_expires.month,
      :year               => cc_expires.year,
      :first_name         => bill_first_name,
      :last_name          => bill_last_name
    )
  end

end
