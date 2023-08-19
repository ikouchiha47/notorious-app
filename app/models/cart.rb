class Cart < ApplicationRecord
  self.primary_key = :cart_id

  validates :cart_id, :product_item_id, presence: true
  validates :cart_token, :cart_token_expires_at, presence: true
  validates :quantity, numericality: { in: 1..5 }

  # has_many :product_items,
  #          foreign_key: 'id',
  #          class_name: 'ProductItem',
  #          primary_key: 'product_item_id'
  #
  # since the cart is denormalized, meaning same cart_token is used for multiple items in cart
  # each cart entry will be related to only one product item
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

    def product_items_for_user(user_id, cart_token)
      Cart.joins(product_item: :product).where(
        cart_token:,
        cart_state: 'processing',
        user_id:
      ).where('carts.product_item_id = product_items.id')
    end
  end
end
