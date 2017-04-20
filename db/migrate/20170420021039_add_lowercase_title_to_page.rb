class AddLowercaseTitleToPage < ActiveRecord::Migration[5.0]
  def change
    add_column :railswiki_pages, :lowercase_title, :string

    add_index :railswiki_pages, :lowercase_title, :unique => true
    add_index :railswiki_pages, :title, :unique => true
  end
end
