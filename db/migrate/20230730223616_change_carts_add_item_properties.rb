class ChangeCartsAddItemProperties < ActiveRecord::Migration[7.0]
  def change
    add_column :carts, :item_properties, :text, null: false, default: ''
  end
end
