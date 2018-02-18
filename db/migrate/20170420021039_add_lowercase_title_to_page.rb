class AddLowercaseTitleToPage < ActiveRecord::Migration[5.0]
  def change
    # We need to have a default value for new columns even if they are NOT NULL
    add_column :railswiki_pages, :lowercase_title, :string, null: false, unique: true, default: "should not be set"
  end
end
