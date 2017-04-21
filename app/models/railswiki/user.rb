module Railswiki
  class User < ApplicationRecord
    has_many :histories, dependent: :nullify, foreign_key: "author_id"

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
