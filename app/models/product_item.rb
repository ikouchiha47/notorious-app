class ProductItem < ApplicationRecord # :nodoc:
  include Uidable

  validates :product_id, presence: true
  validates :quantity, numericality: { only_integer: true }
  validates :measure_in_inches, numericality: { only_integer: true, in: 10..100 }
  validates :measured_part, presence: true
end
