class AddEmailAndImageToUser < ActiveRecord::Migration[5.0]
  def change
    add_column :railswiki_users, :email, :string
    add_column :railswiki_users, :image_url, :string

    add_index :railswiki_users, :email, :unique => true
  end
end
