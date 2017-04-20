require_dependency "railswiki/application_controller"

module Railswiki
  class PagesController < ApplicationController
    before_action :set_page, only: [:show, :edit, :update, :destroy]
    before_action :require_pages_list_permission, only: [:index]
    before_action :require_page_edit_permission, only: [:edit, :update]
    before_action :require_page_create_permission, only: [:new, :create]
    before_action :require_page_delete_permission, only: [:destroy]

    # GET /pages
    def index
      @pages = Page.all
    end

    # GET /pages/1
    def show
    end

    # GET /pages/new
    def new
      @page = Page.new
    end

    # GET /pages/1/edit
    def edit
    end

    # POST /pages
    def create
      @page = Page.new(page_params)

      if @page.save
        redirect_to @page, notice: 'Page was successfully created.'
      else
        render :new
      end
    end

    # PATCH/PUT /pages/1
    def update
      if @page.update(page_params)
        redirect_to @page, notice: 'Page was successfully updated.'
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
        @page = Page.where(id: params[:id]).first ||
            Page.where(title: params[:path]).first ||
            Page.where(lowercase_title: params[:path].downcase).first

        unless @page
          raise ActiveRecord::RecordNotFound, "Could not find page #{params[:id]} in #{params[:path]}"
        end
      end

      # Only allow a trusted parameter "white list" through.
      def page_params
        params.require(:page).permit(:title, :latest_version_id)
      end
  end
end
