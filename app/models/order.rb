class Order < ApplicationRecord
  include Uidable

  validates :cart_id, :user_id, :address_id, :amount, presence: true

  #rn max 4000 rupees cart item allowed
  validates :amount, numericality: {in: 1000..400000 } 
end
