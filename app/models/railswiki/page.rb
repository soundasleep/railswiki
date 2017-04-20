module Railswiki
  class Page < ApplicationRecord
    belongs_to :latest_version

    validates :title, presence: true
  end
end
