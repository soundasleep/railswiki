class CreateRailswikiUploadedFiles < ActiveRecord::Migration[5.0]
  def change
    create_table :railswiki_uploaded_files do |t|
      t.string :file
      t.integer :user_id, null: false, index: true

      t.timestamps
    end
  end
end
