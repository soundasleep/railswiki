module Railswiki
  module PagesHelper
    class SpecialPage
      attr_reader :title, :content, :latest_version

      def initialize(title:, content:)
        @title = title
        @content = content
        @latest_version = nil
      end
    end

    def special_page(title)
      SpecialPage.new({
        title: "Special:#{title}",
        content: special_content(title),
      })
    end

    def special_content(title)
      case title
      when "Welcome"
        "Welcome to your new wiki."
      else
        "Unknown special page '#{title}'"
      end
    end
  end
end
