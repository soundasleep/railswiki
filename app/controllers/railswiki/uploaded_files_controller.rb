require_dependency "railswiki/application_controller"

module Railswiki
  class UploadedFilesController < ApplicationController
    before_action :set_uploaded_file, only: [:show, :edit, :update, :destroy]

    before_action :require_files_list_permission, only: [:index]
    before_action :require_file_edit_permission, only: [:edit, :update]
    before_action :require_file_create_permission, only: [:new, :create]
    before_action :require_file_delete_permission, only: [:destroy]

    # GET /uploaded_files
    def index
      @uploaded_files = UploadedFile.all
    end

    # GET /uploaded_files/image_dialog
    def image_dialog
      index
      render layout: false
    end

    # GET /uploaded_files/1
    def show
    end

    # GET /uploaded_files/new
    def new
      @uploaded_file = UploadedFile.new
      @uploaded_file.user = current_user
      @uploaded_file.title = "#{Time.now}"
    end

    # GET /uploaded_files/1/edit
    def edit
      @uploaded_file.user = current_user
    end

    # POST /uploaded_files
    def create
      @uploaded_file = UploadedFile.new(uploaded_file_params)
      @uploaded_file.user = current_user

      if @uploaded_file.save
        redirect_to @uploaded_file, notice: 'Uploaded file was successfully created.'
      else
        render :new
      end
    end

    # PATCH/PUT /uploaded_files/1
    def update
      @uploaded_file.user = current_user
      if @uploaded_file.update(uploaded_file_params)
        redirect_to @uploaded_file, notice: 'Uploaded file was successfully updated.'
      else
        render :edit
      end
    end

    # DELETE /uploaded_files/1
    def destroy
      @uploaded_file.destroy
      redirect_to uploaded_files_url, notice: 'Uploaded file was successfully destroyed.'
    end

    private
      # Use callbacks to share common setup or constraints between actions.
      def set_uploaded_file
        @uploaded_file = UploadedFile.find(params[:id])
      end

      # Only allow a trusted parameter "white list" through.
      def uploaded_file_params
        params.require(:uploaded_file).permit(:file, :title)
      end
  end
end
