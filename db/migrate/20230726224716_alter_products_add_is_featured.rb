class AlterProductsAddIsFeatured < ActiveRecord::Migration[7.0]
  def change
    change_table :products do |t| 
      t.boolean :is_featured, null: false, default: false
    end
  end
end
