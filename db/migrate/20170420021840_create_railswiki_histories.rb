class CreateRailswikiHistories < ActiveRecord::Migration[5.0]
  def change
    create_table :railswiki_histories do |t|
      t.references :page, foreign_key: true
      t.text :body
      t.references :author, foreign_key: true

      t.timestamps
    end
  end
end
