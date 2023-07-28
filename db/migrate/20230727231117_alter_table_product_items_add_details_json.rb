class AlterTableProductItemsAddDetailsJson < ActiveRecord::Migration[7.0]
  def change
    change_table :product_items do |t|
      t.jsonb :details, null: false, default: {}
    end

    change_table :products do |t|
      t.string :product_type, null: false, default: 'over::tee'
    end

    remove_column :product_items, :measure_in_inches, :integer, null: false, default: 34
    remove_column :product_items, :measured_part, :string
  end
end
