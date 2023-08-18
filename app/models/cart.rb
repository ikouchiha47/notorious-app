class Cart < ApplicationRecord
  self.primary_key = :cart_id

  validates :cart_id, :product_item_id, presence: true
  validates :cart_token, :cart_token_expires_at, presence: true
  validates :quantity, numericality: { in: 1..5 }

  has_one :product_item,
          foreign_key: 'id',
          class_name: 'ProductItem',
          primary_key: 'product_item_id'

  class << self
    def build_token
      SecureRandom.urlsafe_base64(32, false)
    end

    def build_id
      ULID.generate
    end

    def build_with_items(item_id:, item_props: ItemProperties.new)
      Cart.new(
        cart_token_expires_at: 4.days.since.utc,
        cart_state: 'processing',
        shareable: false,
        product_item_id: item_id,
        item_properties: item_props.encode,
        quantity: item_props.quantity
      )
    end

    def product_items_for_user(user_id)
      Cart.joins(:product_items).where(
        cart_token:,
        cart_state: 'processing',
        user_id:
      ).where('cart.product_item_id = product_items.id')
    end
  end
end
