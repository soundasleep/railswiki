module Railswiki
  module PagesHelper
    class SpecialPage
      attr_reader :title, :author, :latest_version

      def initialize(title:)
        @title = title
        @author = nil
        @latest_version = nil
      end

      def builtin_page?
        true
      end

      def content
        case title
        when "Special:Welcome"
          "Welcome to your new wiki."
        when "Special:Header"
          <<-wiki_content
  [[Home]]
  {{Special:Search}}
          wiki_content
        when "Special:Search"
          Railswiki::ApplicationController.render(
            partial: "shared/search",
            assigns: {},
            formats: [:md]
          )
        when "Special:Footer"
          <<-wiki_content
  Copyright {{Special:Year}}
          wiki_content
        when "Special:Formatting"
          Railswiki::ApplicationController.render(
            partial: "shared/formatting",
            assigns: {},
            formats: [:md]
          )
        when "Special:Year"
          "#{Time.now.year}"
        else
          "Unknown special page '#{title}'"
        end
      end
    end

    def special_page(title)
      SpecialPage.new({
        title: "Special:#{title}",
      })
    end

    def special_pages
      [
        special_page("Welcome"),
        special_page("Header"),
        special_page("Footer"),
        special_page("Formatting"),
        special_page("Search"),
        special_page("Year")
      ]
    end

    def is_special_page?(page)
      is_special_page_title?(page.title)
    end

    def is_special_page_title?(title)
      !! special_pages.select { |p| p.title.downcase == title.downcase }.first
    end
  end
end
