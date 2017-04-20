class CreateRailswikiUsers < ActiveRecord::Migration[5.0]
  def change
    create_table :railswiki_users do |t|
      t.string :provider
      t.string :uid
      t.string :name
      t.string :refresh_token
      t.string :access_token
      t.timestamp :expires

      t.timestamps
    end
  end
end
