module Railswiki
  module ApplicationHelper
    # TODO move this into a WikiHelper perhaps
    def include_wiki(page_or_title)
      if page_or_title.is_a?(Page)
        page = page_or_title
      else
        page = Page.where(id: page_or_title).first ||
          Page.where(title: page_or_title).first ||
          Page.where(lowercase_title: page_or_title.downcase).first
      end

      return raw "<!-- no page #{page_or_title} -->" unless page

      return raw markdown.render page.content
    end

    def markdown
      require_dependency "redcarpet"

      # @markdown ||= Redcarpet::Markdown.new(Redcarpet::Render::HTML.new())
      @markdown ||= Redcarpet::Markdown.new(MarkdownRenderer.new())
    end
  end

  class MarkdownRenderer < Redcarpet::Render::HTML
    def preprocess(full_document)
      full_document.gsub(/\[\[([^\]]+)\]\]/i, "[\\1](\\1)")
    end
  end
end
