class Cart < ApplicationRecord

  before_validation :make_cart_id, on: :create


  validates :cart_id, presence: true
  validates :guest_id, 

  private

  def make_cart_id
    self.cart_id = ULID.generate
  end

end
