class Address < ApplicationRecord
  include Uidable

  validates :id, :user_id, :address_line_a, :zip_code, presence: true
  validates :zip_code, numericality: {
    only_integer: true,
    greater_than_or_equal_to: 10_000,
    less_than_or_equal_to: 9_999_999_999
  }

  belongs_to :user

  def self.viewable(user_id)
    Address.where(user_id:).where('deleted_at IS NULL').order(created_at: :desc)
  end
end
