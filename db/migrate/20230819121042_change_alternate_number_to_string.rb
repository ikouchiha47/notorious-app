class ChangeAlternateNumberToString < ActiveRecord::Migration[7.0]
  def up
    change_column :addresses, :alternate_number, :string
  end

  def down
    change_column :addresses, :alternate_number, :integer, using: 'phone::integer'
  end
end
