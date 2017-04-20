module Railswiki
  class ApplicationController < ActionController::Base
    class InvalidRoleError < StandardError; end

    protect_from_forgery with: :exception

    helper_method :current_user, :user_can?

    private

    def current_user
      @current_user ||= Railswiki::User.find(session[:user_id]) if session[:user_id]
    end

    def user_can?(role)
      case role
      when :list_pages
        true
      when :edit_page, :delete_page, :create_page, :list_pages
        current_user.present?
      else
        raise InvalidRoleError, "Unknown role #{role}"
      end
    end

    def require_pages_list_permission
      unless user_can?(:list_pages)
        raise InvalidRoleError, "You must be logged in to access this section"
      end
    end

    def require_page_edit_permission
      unless user_can?(:edit_page)
        raise InvalidRoleError, "You must be logged in to access this section"
      end
    end

    def require_page_create_permission
      unless user_can?(:create_page)
        raise InvalidRoleError, "You must be logged in to access this section"
      end
    end

    def require_page_delete_permission
      unless user_can?(:delete_page)
        raise InvalidRoleError, "You must be logged in to access this section"
      end
    end
  end
end
