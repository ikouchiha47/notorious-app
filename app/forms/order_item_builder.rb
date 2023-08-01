class OrderItemBuilder
  include ActiveModel::Model
  include ActiveModel::Serialization

  attr_accessor :item_id, :size, :quantity

  validates :item_id, :size, :quantity, presence: true
  validates :quantity, numericality: { in: 0..5 }

  def int?(string)
    return true if string.is_a? Numeric
    string.scan(/\D/).empty?
  end

  def quantity=(value)
    @quantity = int?(value) ? value.to_i : 0
  end

  def quantity
    int?(@quantity) ? @quantity.to_i : 0
  end

  def attributes
    {
      item_id:,
      size:,
      quantity:,
    }
  end
end
