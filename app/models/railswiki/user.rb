require "email_validator"

module Railswiki
  class User < ApplicationRecord
    ROLE_ADMIN = "admin"
    ROLE_EDITOR = "editor"
    ROLE_DEFAULT = "user"

    AVAILABLE_ROLES = [ROLE_ADMIN, ROLE_EDITOR, ROLE_DEFAULT]

    has_many :histories, dependent: :nullify, foreign_key: "author_id"
    has_many :uploaded_files, dependent: :nullify
    has_many :invites, dependent: :nullify, foreign_key: "inviting_user_id"
    has_one :invite, dependent: :destroy, foreign_key: "invited_user_id"

    validates :provider, presence: true
    validates :email, presence: true, uniqueness: true, email: true
    validates :role, presence: true, inclusion: { in: AVAILABLE_ROLES }

    # TODO validate role is in AVAILABLE_ROLES

    def expose_json
      {
        id: id,
        name: name,
      }
    end
  end
end
