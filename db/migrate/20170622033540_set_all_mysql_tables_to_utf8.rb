class SetAllMysqlTablesToUtf8 < ActiveRecord::Migration[5.1]
  def change
    adapter_type = connection.adapter_name.downcase.to_sym
    case adapter_type
    when :mysql, :mysql2
      [
        "railswiki_histories",
        "railswiki_invites",
        "railswiki_pages",
        "railswiki_uploaded_files",
        "railswiki_users"
      ].each do |table|
        Railswiki::Page.connection.execute "ALTER TABLE #{table} CONVERT TO CHARACTER SET utf8mb4 COLLATe utf8mb4_bin;"
      end
    else
      puts "Ignoring adapter #{adapter_type}"
    end
  end
end
