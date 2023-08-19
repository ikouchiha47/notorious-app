class Pricing
  include ActiveModel::Validations

  attr_accessor :items_in_cart
  attr_writer :discount, :shipping

  validates :items_in_cart, presence: true

  def initialize(opts = {})
    opts.each do |k, v|
      send("#{k}=", v)
    end
  end

  def discount
    @discount || 0
  end

  def shipping
    @shipping || 0
  end

  def order_total
    return 0 unless valid?

    items_in_cart.sum { |cart_item| calculate_each(cart_item) }
  end

  def order_full
    order_total + shipping - discount
  end

  private

  def calculate_each(cart_item)
    cart_item.quantity * cart_item.product_item.product.price
  end
end
