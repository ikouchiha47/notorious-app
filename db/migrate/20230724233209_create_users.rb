class CreateUsers < ActiveRecord::Migration[7.0]
  def change
    create_table :users, id: false do |t|
      t.string :id, null: false, primary_key: true
      t.string :user_type, null: false, default: 'guest'

      t.string :email, null: false, index: { unique: true }
      t.string :hashed_password, null: false

      t.integer :country_code
      t.integer :number
      t.boolean :verified, null: false, default: false

      t.timestamps null: false
    end
  end
end
