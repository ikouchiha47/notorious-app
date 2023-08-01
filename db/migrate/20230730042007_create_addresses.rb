class CreateAddresses < ActiveRecord::Migration[7.0]
  def change
    create_table :addresses, id: false do |t|
      t.string :id, null: false, primary_key: true
      t.string :user_id, null: false, index: true
      t.string :address_line_a, null: false
      t.text :address_line_b
      t.integer :zip_code, null: false
      t.integer :alternate_number

      t.timestamps null: false
    end
  end
end
