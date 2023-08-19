class GuestOrderBuilderForm
  include ActiveModel::Model
  include ActiveModel::Serialization

  attr_accessor :success,
                :email,
                :item,
                :address_line_a,
                :address_line_b,
                :zip_code,
                :phone_country_code,
                :phone_number,
                :alternate_phone_number

  attr_reader :order

  validates :email,
            :phone_country_code,
            :phone_number,
            :zip_code,
            :item,
            :address_line_a, presence: true

  validates :zip_code, numericality: {
    only_integer: true,
    greater_than_or_equal_to: 10_000,
    less_than_or_equal_to: 9_999_999_999
  }

  validates :phone_country_code, numericality: {
    only_integer: true,
    greater_than_or_equal_to: 1,
    less_than_or_equal_to: 999
  }

  validates :phone_number, length: { in: 6..20 }

  validates :email, email_format: true

  def int?(string)
    return true if string.is_a? Numeric

    string.scan(/\D/).empty?
  end

  def phone_number=(value)
    @phone_number = int?(value) ? value.to_i : 0
  end

  def phone_country_code=(value)
    @phone_country_code = int?(value) ? value.to_i : 0
  end

  def zip_code=(value)
    @zip_code = int?(value) ? value.to_i : 0
  end

  def order_item_builder=(attrs = {})
    @item ||= OrderItemBuilder.new(attrs)
  end

  def alternate_number
    return alternate_phone_number if alternate_phone_number.present?

    "+#{phone_country_code}-#{phone_number}"
  end

  # we are here meaning the user existence is validated
  # here the password will be generate for first time users
  # we also need to validate and save the address
  # we need to create an order with a random cart_id prefixed with guest_{cart_id}

  def save!
    @success = false
    return unless valid?

    cart_id = "guest_#{ULID.generate}"

    ActiveRecord::Base.transaction do
      password = SecureRandom.hex(8)
      order_item = ProductItem.find(@item.item_id)

      user = User.create!(
        email:,
        password:,
        country_code: phone_country_code,
        number: phone_number,
        user_type: 'guest',
        verified: false
      )

      address = Address.create!(
        user_id: user.id,
        address_line_a:,
        address_line_b:,
        zip_code:,
        alternate_number:
      )

      amount = @item.quantity * order_item.product.price
      p @item.quantity
      p order_item.product.price

      @order = Order.create!({
                               cart_id:,
                               user_id: user.id,
                               address_id: address.id,
                               amount:,
                               payment_status: 'pending',
                               order_status: 'pending',
                               alternate_number:,
                               order_token: SecureRandom.hex(16),
                               order_token_expires_at: 2.days.since.utc
                             })

      order_item.update!(quantity: order_item.quantity - 1)
      @success = true
    end
  end
end
