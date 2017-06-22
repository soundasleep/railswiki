module Railswiki
  module TitleHelper
    def title(page_title)
      content_for(:title) { page_title.join(" - ") }
    end
  end
end
