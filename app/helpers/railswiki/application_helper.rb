require_dependency "redcarpet"

module Railswiki
  module ApplicationHelper
    include WikiHelper

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
end
