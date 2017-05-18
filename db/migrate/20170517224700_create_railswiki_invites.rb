class CreateRailswikiInvites < ActiveRecord::Migration[5.0]
  def change
    create_table :railswiki_invites do |t|
      t.string :email, null: false, unique: true
      t.datetime :accepted_at, null: true
      t.integer :inviting_user_id, null: false, index: true
      t.integer :invited_user_id, null: true, index: true

      t.timestamps
    end
  end
end
