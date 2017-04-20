module Railswiki
  class History < ApplicationRecord
    belongs_to :page
    belongs_to :author, class_name: "User"
  end
end
