module Railswiki
  module PagesHelper
    class SpecialPage
      attr_reader :title, :content, :author, :latest_version

      def initialize(title:, content:)
        @title = title
        @content = content
        @author = nil
        @latest_version = nil
      end

      def builtin_page?
        true
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
      when "Header"
        <<-wiki_content
[[Home]]
{{Special:Search}}
        wiki_content
      when "Search"
        Railswiki::ApplicationController.render(
          partial: "shared/search",
          assigns: {}
        )
      when "Footer"
        <<-wiki_content
Copyright {{Special:Year}}
        wiki_content
      when "Year"
        "#{Time.now.year}"
      else
        "Unknown special page '#{title}'"
      end
    end

    def special_pages
      [
        special_page("Welcome"),
        special_page("Header"),
        special_page("Footer"),
        special_page("Search"),
        special_page("Year")
      ]
    end
  end
end
