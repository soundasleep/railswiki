class AddLowercaseTitleToPage < ActiveRecord::Migration[5.0]
  def change
    add_column :railswiki_pages, :lowercase_title, :string, null: false, unique: true
  end
end
