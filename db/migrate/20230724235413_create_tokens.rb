class CreateTokens < ActiveRecord::Migration[7.0]
  def change
    create_table :tokens, id: false do |t|
      t.string :token_type, null: false
      t.string :token, null: false
      t.datetime :expires_at, null: false
      t.string :refresh_token
      t.datetime :refresh_expires_at
      t.boolean :revoked, null: false, default: false
      t.string :user_id, null: false, index: true
    end

    add_index :tokens, %i[token token_type]
    add_index :tokens, %i[token refresh_token]
  end
end
