class AddLastLoginToUser < ActiveRecord::Migration[5.0]
  def change
    add_column :railswiki_users, :last_login, :timestamp
  end
end
