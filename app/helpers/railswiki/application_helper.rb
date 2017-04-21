require_dependency "redcarpet"

module Railswiki
  module ApplicationHelper
    # TODO move this into a WikiHelper perhaps
    def include_wiki(page_or_title)
      if page_or_title.is_a?(Page)
        page = page_or_title
      else
        page = select_page(page_or_title)
      end

      return raw "<!-- no page #{page_or_title} -->" unless page

      return raw markdown.render page.content
    end

    def select_page(page_or_title)
      @select_pages ||= Hash.new do |hash, ref|
        hash[ref] = Page.where(id: ref).
          or(Page.where(title: [ref, unprettify_title(ref)]).
          or(Page.where(lowercase_title: [ref.downcase, unprettify_title(ref.downcase)]))).
          # joins("INNER JOIN railswiki_histories ON railswiki_pages.id=railswiki_histories.page_id AND railswiki_pages.latest_version_id=railswiki_histories.id").
          first
        end
      @select_pages[page_or_title]
    end

    def markdown
      # @markdown ||= Redcarpet::Markdown.new(Redcarpet::Render::HTML.new())
      @markdown ||= Redcarpet::Markdown.new(MarkdownRenderer.new())
    end

    def time_ago(time)
      content_tag "span", "#{time_ago_in_words(time)} ago", title: "#{time}", class: "time_ago"
    end
  end

  class MarkdownRenderer < Redcarpet::Render::HTML
    def preprocess(full_document)
      full_document.gsub(/\[\[([^\]]+)\]\]/i, "[\\1](\\1)")
    end
  end
end
