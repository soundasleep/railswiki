require "email_validator"

module Railswiki
  class Invite < ApplicationRecord
    belongs_to :inviting_user, class_name: "User"
    belongs_to :invited_user, class_name: "User", optional: true

    validates :email, presence: true, uniqueness: true, email: true
    validates :inviting_user, presence: true
    validates :role, presence: true, inclusion: { in: User::AVAILABLE_ROLES }

    validate :user_cannot_already_be_registered

    def user_cannot_already_be_registered
      if accepted_at.nil? && User.where(email: email).any?
        errors.add(:email, "is already registered as a user")
      end
    end
  end
end
