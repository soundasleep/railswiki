class SetAllMysqlTablesToUtf8 < ActiveRecord::Migration[5.1]
  MAX_VARCHAR_LENGTH = 191

  def change
    # we have to reduce the length of varchar(255) to varchar(191)
    # so it fits in 255 bytes with UTF8 for MySQL
    change_table :railswiki_users do |t|
      t.change :provider,      :string, limit: MAX_VARCHAR_LENGTH
      t.change :uid,           :string, limit: MAX_VARCHAR_LENGTH
      t.change :name,          :string, limit: MAX_VARCHAR_LENGTH
      t.change :refresh_token, :string, limit: MAX_VARCHAR_LENGTH
      t.change :access_token,  :string, limit: MAX_VARCHAR_LENGTH
      t.change :email,         :string, limit: MAX_VARCHAR_LENGTH
      t.change :image_url,     :string, limit: MAX_VARCHAR_LENGTH
      t.change :role,          :string, limit: MAX_VARCHAR_LENGTH
    end

    change_table :railswiki_invites do |t|
      t.change :email,         :string, limit: MAX_VARCHAR_LENGTH
      t.change :role,          :string, limit: MAX_VARCHAR_LENGTH
    end

    change_table :railswiki_pages do |t|
      t.change :title,         :string, limit: MAX_VARCHAR_LENGTH
      t.change :lowercase_title, :string, limit: MAX_VARCHAR_LENGTH
    end

    change_table :railswiki_uploaded_files do |t|
      t.change :file,          :string, limit: MAX_VARCHAR_LENGTH
      t.change :title,         :string, limit: MAX_VARCHAR_LENGTH
    end

    adapter_type = connection.adapter_name.downcase.to_sym
    case adapter_type
    when :mysql, :mysql2
      # then change the character sets
      [
        "railswiki_histories",
        "railswiki_invites",
        "railswiki_pages",
        "railswiki_uploaded_files",
        "railswiki_users"
      ].each do |table|
        Railswiki::Page.connection.execute "ALTER TABLE #{table} CONVERT TO CHARACTER SET utf8mb4 COLLATE utf8mb4_bin;"
      end
    else
      puts "Ignoring adapter #{adapter_type}"
    end
  end
end
