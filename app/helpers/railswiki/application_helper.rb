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
          first
        end
      @select_pages[page_or_title]
    end

    def markdown
      @markdown ||= Redcarpet::Markdown.new(MarkdownRenderer.new(), markdown_options)
    end

    def markdown_options
      {
        tables: true,
        no_intra_emphasis: true
      }
    end

    def time_ago(time)
      description = if time.present?
        "#{time_ago_in_words(time)} ago"
      else
        "never!"
      end

      content_tag "span", description, title: "#{time}", class: "time_ago"
    end

    def user_link(user)
      if user.present?
        link_to user.name, user
      else
        content_tag "i", "nobody!", class: "invalid_user"
      end
    end
  end

  class MarkdownRenderer < Redcarpet::Render::HTML
    def preprocess(full_document)
      # Wiki links
      full_document.gsub(/\[\[([^\]]+)\]\]/i, "[\\1](\\1)")
    end

    # Image resizing as per https://github.com/vmg/redcarpet/issues/487
    def image(link, title, alt_text)
      if link =~ /^(.+?)\s*=+(\d+)(?:px|)$/
        # ![alt](url.png =100px)
        # ![alt](url.png =100)
        %(<img src="#{$1}" style="max-width: #{$2}px" alt="#{alt_text}">)
      elsif link =~ /^(.+?)\s*=+(\d+)(?:px|)x(\d+)(?:px|)$/
        # ![alt](url.png =30x50)
        %(<img src="#{$1}" style="max-width: #{$2}px; max-height: #{$3}px;" alt="#{alt_text}">)
      else
        %(<img src="#{link}" title="#{title}" alt="#{alt_text}">)
      end
    end
  end
end
