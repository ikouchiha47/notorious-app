class AddDeletedAtToAddress < ActiveRecord::Migration[7.0]
  def change
    add_column :addresses, :deleted_at, :datetime, null: true
    add_column :addresses, :tag, :string, null: false, default: 'Address'
  end
end
