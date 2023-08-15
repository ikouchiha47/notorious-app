class ChangeTokensAlterToken < ActiveRecord::Migration[7.0]
  def change
    rename_column :tokens, :token, :hashed_token
    rename_column :tokens, :refresh_token, :hashed_refresh_token
  end
end
