class AddRoleToInvite < ActiveRecord::Migration[5.0]
  def change
    add_column :railswiki_invites, :role, :string, null: false, default: "user"
  end
end
