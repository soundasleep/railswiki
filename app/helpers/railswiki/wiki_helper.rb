require_dependency "redcarpet"

module Railswiki
  module WikiHelper
    include PagesHelper

    def include_wiki(page_or_title)
      if page_or_title.is_a?(Page)
        page = page_or_title
      else
        page = select_page(page_or_title)
      end

      return raw "<!-- no page #{page_or_title} -->" unless page

      wiki_classes = "wiki-included wiki-#{classify_title(page.title)}"

      return raw "<div class=\"#{wiki_classes}\">#{markdown_without_wrap.render page.content}</div>"
    end

    def include_wiki_class(page)
      "<div>" + yield + "</div>"
    end

    def select_page(page_or_title)
      @select_pages ||= Hash.new do |hash, ref|
        # Don't try to include blank pages in here
        return if ref.blank?

        hash[ref] = Page.where(id: ref).
          or(Page.where(title: [ref, unprettify_title(ref)]).
          or(Page.where(lowercase_title: [ref.downcase, unprettify_title(ref.downcase)]))).
          first
        hash[ref] ||= special_pages.select { |page| page.title == ref }.first
      end
      @select_pages[page_or_title]
    end

    def prettify_title(title)
      title.gsub(/ /, "_")
    end

    def unprettify_title(title)
      title.present? ? title.gsub(/_/, " ") : nil
    end

    def classify_title(title)
      title.gsub(/[^a-z0-9-_]+/i, "_")
    end

    def wiki_path(page, options = {})
      page = "." if page == ""

      if page.respond_to?(:title)
        url_helpers.title_path(prettify_title(page.title), options)
      else
        url_helpers.title_path(prettify_title(page), options)
      end
    end

    def url_helpers
      Railswiki::Engine.routes.url_helpers
    end

    def markdown
      @markdown ||= Redcarpet::Markdown.new(MarkdownRenderer.new(), markdown_options)
    end

    def markdown_without_wrap
      @markdown_without_wrap ||= Redcarpet::Markdown.new(MarkdownRendererWithoutWrap.new(), markdown_options)
    end

    def markdown_options
      {
        tables: true,
        no_intra_emphasis: true
      }
    end
  end

  class MarkdownRenderer < Redcarpet::Render::HTML
    include WikiHelper

    def preprocess(full_document)
      # Include templates {{template}}
      full_document = full_document.gsub(/\{\{([^\}]+)\}\}/i) do |match|
        template = select_page($1)
        if template && template.content
          # Because we are only including the raw content here, and not
          # rendering the markdown before including it, it's not possible
          # to have a stack overflow here. If this ever changes to
          # somehow call preprocess() again, you MUST add a test to prevent
          # infinite inclusion.
          # It also means we don't need to `raw` the output.
          template.content
        else
          "*** Unknown template #{$1} ***"
        end
      end

      # Wiki links [[link|title]]
      full_document = full_document.gsub(/\[\[([^\n]+?)\|([^\n]+?)\]\]/i) do |match|
        "[#{$2}](#{wiki_path($1)})"
      end

      # Wiki links [[link]]
      full_document = full_document.gsub(/\[\[([^\n]+?)\]\]/i) do |match|
        "[#{$1}](#{wiki_path($1)})"
      end

      full_document
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

  # Remove the <p> tags around the output as per https://github.com/vmg/redcarpet/issues/92
  class MarkdownRendererWithoutWrap < MarkdownRenderer
    def postprocess(full_document)
      Regexp.new(/\A<p>(.*)<\/p>\Z/m).match(full_document)[1] rescue full_document
    end
  end
end
