require_dependency 'carrierwave'
require_dependency 'carrierwave/orm/activerecord'

module Railswiki
  class UploadedFile < ApplicationRecord
    mount_uploader :file, FileUploader

    belongs_to :user

    validates :title, presence: true, uniqueness: true
    validate :file_exists

    delegate :content_type, to: :file

    def file_url
      file.url.sub "public/", ""
    end

    def is_image?
      file.content_type && MIME::Types[file.content_type].any? &&
          MIME::Types[file.content_type].first.media_type == "image"
    end

    private

    def file_exists
      if file.file.nil?
        errors.add(:file, "does not exist")
      end
    end
  end
end
