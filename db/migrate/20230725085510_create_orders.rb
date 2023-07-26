class CreateOrders < ActiveRecord::Migration[7.0]
  def change
    # one use has only one cart which will be in processing
    create_table :carts, id: false do |t|
      t.string :cart_id, null: false, index: true
      t.string :user_id, null: false
      t.string :product_item_id, null: false
      t.integer :quantity, null: false, default: 0

      # cart_state: processing -> processed
      t.string :cart_state, null: false, default: 'processing'
      # t.datetime :cart_expires_in

      t.timestamps null: false
    end

    create_table :orders, id: false do |t|
      t.string :ulid, null: false, index: { unique: true }
      t.string :cart_id, null: false
      t.string :user_id, null: false
      t.string :address_id, null: false
      t.integer :amount, null: false, default: 0

      # payment status: pending -> completed/failed/reverted
      t.string :payment_status, null: false, default: 'pending'

      # order status:
      # pending -> calluser
      # calluser -> success/failure
      # pending -> failure (admin only)
      t.string :order_status, null: false, default: 'pending'

      t.timestamps null: false
    end
  end
end
