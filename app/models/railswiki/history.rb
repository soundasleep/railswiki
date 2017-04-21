module Railswiki
  class History < ApplicationRecord
    belongs_to :page
    belongs_to :author, class_name: "User"

    def expose_json
      {
        id: id,
        updated_at: created_at,
        content: body
      }
    end
  end
end
