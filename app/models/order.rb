class Order < ApplicationRecord
  include Uidable
  include AASM

  validates :cart_id, :user_id, :address_id, :amount, presence: true

  # rn max 4000 rupees cart item allowed (in paisa)
  validates :amount, numericality: { in: 1000..400_000 }

  # state changes
  # order_status: 'pending', 'paidfor', 'awaiting-confirmation', 'delivered', 'lost', 'rejected', 'cancelled'
  #
  aasm do
    state :pending, initial: true
    state :paidfor, :await_confirm
    state :delivered, :lost, :rejected, :cancelled

    event :place do
      transitions from: :pending, to: %i[paidfor cancelled]
    end

    event :paid do
      transitions from: :paidfor, to: %i[await_confirm cancelled]
    end

    event :completed do
      transitions from: :await_confirm, to: :delivered
    end

    event :failed do
      transitions from: :await_confirm, to: %i[lost rejected]
    end
  end
end
