class CreateRailswikiInvites < ActiveRecord::Migration[5.0]
  def change
    create_table :railswiki_invites do |t|
      t.string :email, null: false, unique: true
      t.datetime :accepted_at, null: true
      t.references :inviting_user, null: false, foreign_key: true
      t.references :invited_user, null: true, foreign_key: true

      t.timestamps
    end
  end
end
