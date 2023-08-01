class Address < ApplicationRecord
  include Uidable

  validates :id, :user_id, :address_line_a, :zip_code, presence: true
  validates :zip_code, numericality: {
    only_integer: true,
    greater_than_or_equal_to: 10000,
    less_than_or_equal_to: 9999999999
  }

  belongs_to :user
end
