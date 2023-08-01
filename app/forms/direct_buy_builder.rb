class DirectBuyBuilder
  include ActiveModel::Model

  attr_accessor :item_id, :size

  validates :item_id, :size, presence: true
end
