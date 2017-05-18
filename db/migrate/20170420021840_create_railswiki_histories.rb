class CreateRailswikiHistories < ActiveRecord::Migration[5.0]
  def change
    create_table :railswiki_histories do |t|
      t.integer :page_id, null: false, index: true
      t.text :body
      t.integer :author_id, null: false, index: true

      t.timestamps
    end
  end
end
