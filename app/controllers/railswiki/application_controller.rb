module Railswiki
  class ApplicationController < ActionController::Base
    class InvalidRoleError < StandardError; end

    protect_from_forgery with: :exception

    helper_method :current_user, :user_can?, :prettify_title, :unprettify_title, :wiki_path

    private

    def current_user
      @current_user ||= Railswiki::User.where(id: session[:user_id]).first if session[:user_id]
    end

    def user_can?(role)
      case role
      when :list_pages
        true
      when :edit_page, :delete_page, :create_page, :list_pages, :history_page
        current_user && ["admin", "editor"].include?(current_user.role)
      when :list_users
        current_user && ["admin", "editor"].include?(current_user.role)
      when :edit_user, :delete_user
        current_user && ["admin"].include?(current_user.role)
      when :list_histories, :delete_history
        current_user && ["admin", "editor"].include?(current_user.role)
      when :see_page_author
        current_user && ["admin", "editor"].include?(current_user.role)
      when :edit_file, :delete_file, :create_file, :list_files
        current_user && ["admin", "editor"].include?(current_user.role)
      else
        raise InvalidRoleError, "Unknown role #{role}"
      end
    end

    def require_pages_list_permission
      require_role :list_pages
    end

    def require_page_edit_permission
      require_role :edit_page
    end

    def require_page_create_permission
      require_role :create_page
    end

    def require_page_delete_permission
      require_role :delete_page
    end

    def require_page_history_permission
      require_role :history_page
    end

    def require_users_list_permission
      require_role :list_users
    end

    def require_user_edit_permission
      require_role :edit_user
    end

    def require_user_delete_permission
      require_role :delete_user
    end

    def require_histories_list_permission
      require_role :list_histories
    end

    def require_history_delete_permission
      require_role :delete_history
    end

    def require_files_list_permission
      require_role :list_files
    end

    def require_file_edit_permission
      require_role :edit_file
    end

    def require_file_create_permission
      require_role :create_file
    end

    def require_file_delete_permission
      require_role :delete_file
    end

    def require_role(role)
      unless user_can?(role)
        raise InvalidRoleError, "You must be logged in to access this section"
      end
    end

    # TODO probably want this in a separate module
    def prettify_title(title)
      title.gsub(/ /, "_")
    end

    def unprettify_title(title)
      title.gsub(/_/, " ")
    end

    def wiki_path(page, options = {})
      page = "." if page == ""

      if page.respond_to?(:title)
        title_path(prettify_title(page.title), options)
      else
        title_path(prettify_title(page), options)
      end
    end
  end
end
