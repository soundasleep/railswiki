class CreateRailswikiPages < ActiveRecord::Migration[5.0]
  def change
    create_table :railswiki_pages do |t|
      t.string :title
      t.references :latest_version, foreign_key: true

      t.timestamps
    end
  end
end
