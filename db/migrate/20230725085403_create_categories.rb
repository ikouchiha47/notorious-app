class CreateCategories < ActiveRecord::Migration[7.0]
  def change
    create_table :categories, id: false do |t|
      t.integer :id, null: false, primary_key: true
      t.string :type, null: false
      t.string :name, null: false

      t.timestamps null: false
    end
  end
end
