class ProductItem < ApplicationRecord # :nodoc:
  include Uidable
 

  belongs_to :product

  validates :product_id, presence: true
  validates :quantity, numericality: { only_integer: true }
  validates :details, presence: true
end
