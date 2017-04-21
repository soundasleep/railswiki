require_dependency 'carrierwave'
require_dependency 'carrierwave/orm/activerecord'

module Railswiki
  class UploadedFile < ApplicationRecord
    mount_uploader :file, FileUploader

    belongs_to :user

    validate :file_exists

    def file_url
      file.url.sub "public/", ""
    end

    def is_image?
      file.content_type && MIME::Types[file.content_type].first.media_type == "image"
    end

    private

    def file_exists
      if file.file.nil?
        errors.add(:file, "No such file")
      end
    end
  end
end
