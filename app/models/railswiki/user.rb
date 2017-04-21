module Railswiki
  class User < ApplicationRecord
    AVAILABLE_ROLES = ["admin", "editor", ""]

    has_many :histories, dependent: :nullify, foreign_key: "author_id"
    has_many :files, dependent: :nullify

    validates :provider, presence: true
    validates :email, presence: true, uniqueness: true

    def expose_json
      {
        id: id,
        name: name,
      }
    end
  end
end
