class GuestBuyForm
  include ActiveModel::Model

  attr_accessor :item_id, :size, :quantity

  validates :item_id, :size, :quantity, presence: true
end
