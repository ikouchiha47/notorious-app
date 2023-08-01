class ChangeOrdersAddAlterPhone < ActiveRecord::Migration[7.0]
  def change
    add_column :orders, :alternate_number, :string
  end
end
