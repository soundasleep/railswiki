class CreateRailswikiPages < ActiveRecord::Migration[5.0]
  def change
    create_table :railswiki_pages do |t|
      t.string :title, null: false, unique: true
      t.integer :latest_version_id, null: true, index: true

      t.timestamps
    end
  end
end
