class ChangeTokensUserIdToResourceId < ActiveRecord::Migration[7.0]
  def change
    rename_column :tokens, :user_id, :resource_id
    add_column :tokens, :resource_type, :string
  end
end
