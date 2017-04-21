class AddRoleToUser < ActiveRecord::Migration[5.0]
  def change
    add_column :railswiki_users, :role, :string

    add_index :railswiki_users, :role
  end
end
