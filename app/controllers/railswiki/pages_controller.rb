require_dependency "railswiki/application_controller"

module Railswiki
  class PagesController < ApplicationController
    before_action :set_page, only: [:show, :edit, :update, :destroy, :history]
    before_action :require_pages_list_permission, only: [:index]
    before_action :require_page_edit_permission, only: [:edit, :update]
    before_action :require_page_create_permission, only: [:new, :create]
    before_action :require_page_delete_permission, only: [:destroy]
    before_action :require_page_history_permission, only: [:history]

    helper ApplicationHelper

    # GET /pages
    def index
      @pages = Page.all
    end

    # GET /pages/1
    def show
      respond_to do |format|
        format.html
        format.json { render json: @page.expose_json }
      end
    end

    # GET /pages/1/history
    def history
      @histories = @page.histories
      respond_to do |format|
        format.html
        format.json { render json: @histories.map { |history| history.expose_json } }
      end
    end

    # GET /pages/new
    def new
      @page = Page.new
      @page.title = params[:title] if params[:title]
    end

    # GET /pages/1/edit
    def edit
    end

    # POST /pages
    def create
      @page = Page.new(page_params)

      if @page.save
        update_content
        redirect_to wiki_path(@page), notice: 'Page was successfully created.'
      else
        render :new
      end
    end

    # PATCH/PUT /pages/1
    def update
      if @page.update(page_params)
        update_content
        redirect_to wiki_path(@page), notice: 'Page was successfully updated.'
      else
        render :edit
      end
    end

    # DELETE /pages/1
    def destroy
      @page.destroy
      redirect_to pages_url, notice: 'Page was successfully destroyed.'
    end

    private

    # Use callbacks to share common setup or constraints between actions.
    def set_page
      title = params[:id] || params[:page_id] || params[:path]
      raise ActiveRecord::RecordNotFound, "Unknown page request" unless title

      @page = Page.where(id: title).first ||
          Page.where(title: title).first ||
          Page.where(title: unprettify_title(title)).first ||
          Page.where(lowercase_title: title.downcase).first ||
          Page.where(lowercase_title: unprettify_title(title).downcase).first

      unless @page
        if user_can?(:create_page)
          return redirect_to new_page_path(title: title)
        end

        raise ActiveRecord::RecordNotFound, "Could not find page '#{title}'"
      end
    end

    def update_content
      # Create a new history
      history = @page.histories.create!({
        author: current_user,
        body: params.require(:page)[:content]
      })
      @page.update_attributes! latest_version_id: history.id
    end

    # Only allow a trusted parameter "white list" through.
    def page_params
      params.require(:page).permit(:title, :latest_version_id)
    end
  end
end
