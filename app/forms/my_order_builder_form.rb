class MyOrderBuilderForm < ApplicationForm
  attr_accessor :success, :address_id, :user_id, :cart_token

  attr_reader :order

  validates :address_id, :user_id, :cart_token, presence: true

  def cart_items
    @cart_items ||= Cart.product_items_for_user(user_id, cart_token)
  end

  def amount
    unless cart_items.present?
      errors.add(:base, 'Empty Cart')
      return
    end

    Pricing.new(items_in_cart: cart_items).order_full
  end

  def save!
    @success = false

    amount
    raise OrderErrors::ValidationFailed unless valid?

    cart_id = cart_items.first.id
    @order = Order.create!({
                             cart_id:,
                             user_id:,
                             address_id:,
                             amount:,
                             payment_status: 'pending',
                             order_status: 'pending',
                             order_token: SecureRandom.hex(16),
                             order_token_expires_at: 2.days.since.utc
                           })
    @success = true

    Cart.mark_as_ordered('', cart_id)
    @success
  end
end
