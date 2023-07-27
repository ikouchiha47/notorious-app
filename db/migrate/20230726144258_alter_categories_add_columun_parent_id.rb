class AlterCategoriesAddColumunParentId < ActiveRecord::Migration[7.0]
  def change
    change_table :categories do |t|
      t.integer :parent_category_id, index: true
    end
  end
end
