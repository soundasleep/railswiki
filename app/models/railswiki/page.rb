module Railswiki
  class Page < ApplicationRecord
    belongs_to :latest_version

    validates :title, presence: true, uniqueness: true
    validates :lowercase_title, presence: true, uniqueness: true

    before_validation :save_lowercase_title, on: [:create, :update]
    validate :lowercase_title_must_equal_title

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
