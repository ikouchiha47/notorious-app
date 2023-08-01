class Cart < ApplicationRecord
  validates :cart_id, :product_item_id, presence: true
  validates :cart_token, :cart_token_expires_at, presence: true
  validates :quantity, numericality: { in: 1..5 }


  has_one :product_item,
           foreign_key: 'id',
           class_name: 'ProductItem',
           primary_key: 'product_item_id'

  def self.new_with_item(item_id:, size:, quantity:)
    token = SecureRandom.urlsafe_base64(32, false)

    Cart.new(
      cart_id: ULID.generate,
      cart_token: token,
      cart_token_expires_at: cart_token_expiry,
      cart_state: "processing",
      shareable: false,
      product_item_id: item_id,
      item_properties: ItemProperties.new(size:).encode,
      quantity: quantity,
    )
  end
end
