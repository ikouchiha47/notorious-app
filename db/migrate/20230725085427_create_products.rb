class CreateProducts < ActiveRecord::Migration[7.0]
  def change
    create_table :products, id: false do |t|
      t.string :ulid, null: false, primary_key: true
      t.string :sku, null: false, index: true
      t.string :sku_provider, null: false
      t.string :title, null: false
      t.text :description
      t.integer :price, null: false
      t.text :images, null: false
      t.boolean :available, null: false, default: false
      t.boolean :is_limited_edition, null: false, default: true
      t.integer :category_id, null: false

      t.timestamps null: false
    end

    create_table :product_items, id: false do |t|
      t.string :ulid, null: false, primary_key: true
      # unisex, male, female
      t.string :gender, null: false, default: 'unisex'
      t.string :product_id, null: false, index: true
      t.integer :quantity, null: false, default: 10 # this is unused for now
      t.integer :measure_in_inches, null: false
      t.string :measured_part # waist, chest
      t.text :locations

      t.timestamps null: false
    end
  end
end
