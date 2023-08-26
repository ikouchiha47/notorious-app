class GuestOrderBuilderForm < ApplicationForm
  attr_accessor :success,
                :email

  attr_reader :order, :phone_number, :phone_country_code, :address_form_builder, :order_item_builder

  validates :email,
            :phone_country_code,
            :phone_number,
            :order_item_builder,
            :address_form_builder, presence: true

  validates :phone_number, length: { in: 6..20 }
  validates :email, email_format: true

  validate do
    validates_associated(order_item_builder)
    validates_associated(address_form_builder)
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
    @order_item_builder ||= OrderItemBuilder.new(attrs)
  end

  def address_form_builder=(attrs = {})
    @address_form_builder ||= AddressFormBuilder.new(attrs)
  end

  # we are here meaning the user existence is validated
  # here the password will be generate for first time users
  # we also need to validate and save the address
  # we need to create an order with a random cart_id prefixed with guest_{cart_id}

  def aggregate_errors(nested_form)
    nested_form.valid?
    #
    # nested_form.errors.each do |attribute, message|
    #   errors.add(attribute, message)
    # end
  end

  def save!
    @success = false
    return unless valid?

    cart_id = "guest_#{ULID.generate}"

    ActiveRecord::Base.transaction do
      password = SecureRandom.hex(8)
      # check for quantity
      order_item = ProductItem.find(@order_item_builder.item_id)

      user = User.create!(
        email:,
        password:,
        country_code: phone_country_code,
        number: phone_number,
        user_type: 'guest',
        verified: false
      )

      @address_form_builder.country_code = phone_country_code
      @address_form_builder.alternate_phone_number = phone_number

      address = Address.create!(
        user_id: user.id,
        address_line_a: @address_form_builder.address_line_a,
        address_line_b: @address_form_builder.address_line_b,
        zip_code: @address_form_builder.zip_code,
        alternate_number: @address_form_builder.alternate_number
      )

      amount = @order_item_builder.quantity * order_item.product.price
      # p @item.quantity
      # p order_item.product.price

      @order = Order.create!({
                               cart_id:,
                               user_id: user.id,
                               address_id: address.id,
                               amount:,
                               payment_status: 'pending',
                               order_status: 'pending',
                               alternate_number: @address_form_builder.alternate_number,
                               order_token: SecureRandom.hex(16),
                               order_token_expires_at: 2.days.since.utc
                             })

      ## TODO: reduce the item quantity in Product
      order_item.update!(quantity: order_item.quantity - 1)
      @success = true
    end

    # move to worker
    Cart.mark_as_ordered('', cart_id)
    @success
  end
end
