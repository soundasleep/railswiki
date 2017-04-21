module Railswiki
  class Page < ApplicationRecord
    has_many :histories, dependent: :destroy

    validates :title, presence: true, uniqueness: true
    validates :lowercase_title, presence: true, uniqueness: true

    before_validation :save_lowercase_title, on: [:create, :update]
    validate :lowercase_title_must_equal_title

    delegate :author, to: :latest_version, allow_nil: true

    def content
      latest_version.present? ? latest_version.body : "(empty)"
    end

    def latest_version
      @latest_version ||= histories.where(id: latest_version_id).first
    end

    def expose_json
      {
        id: id,
        title: title,
        updated_at: latest_version.created_at,
        content: content
      }
    end

    private

    def lowercase_title_must_equal_title
      if title.downcase != lowercase_title.downcase
        errors.add(:lowercase_title, "Mismatching lowercase title")
      end
    end

    def save_lowercase_title
      self.lowercase_title = self.title.downcase
    end
  end
end
