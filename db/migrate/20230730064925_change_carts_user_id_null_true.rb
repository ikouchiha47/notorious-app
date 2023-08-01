class ChangeCartsUserIdNullTrue < ActiveRecord::Migration[7.0]
  def change
    reversible do |dir|
      dir.up do
        change_column :carts, :user_id, :string, null: true
      end

      dir.down do
        change_column :carts, :user_id, :string, null: false
      end
    end

    add_column :carts, :cart_token, :string, index: true
    add_column :carts, :cart_token_expires_at, :datetime, null: false
    add_column :carts, :shareable, :boolean, default: false

    add_column :orders, :order_token, :string, index: true
    add_column :orders, :order_token_expires_at, :datetime, null: false
  end
end
