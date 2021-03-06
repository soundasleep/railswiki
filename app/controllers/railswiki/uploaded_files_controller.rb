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
      @uploaded_files = UploadedFile.all.select { |file| file.is_image? }
      render layout: false
    end

    # GET /uploaded_files/file_dialog
    def file_dialog
      @uploaded_files = UploadedFile.all.reject { |file| file.is_image? }
      render layout: false
    end

    # GET /uploaded_files/1
    def show
    end

    # GET /uploaded_files/1/download
    def download
      @uploaded_file = UploadedFile.where(title: params[:title]).first
      unless @uploaded_file
        raise ActiveRecord::RecordNotFound, "Could not find file '#{params[:title]}'"
      end
      redirect_to @uploaded_file.file_url
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
      @uploaded_file.title = "#{Time.now}"

      if @uploaded_file.save
        @uploaded_file.update_attributes! title: @uploaded_file.file_identifier

        redirect_to @uploaded_file, notice: 'Uploaded file was successfully created.'
      else
        render :new
      end
    end

    # PATCH/PUT /uploaded_files/1
    def update
      @uploaded_file.user = current_user
      @uploaded_file.title = "#{Time.now}"

      if @uploaded_file.update(uploaded_file_params)
        @uploaded_file.update_attributes! title: @uploaded_file.file_identifier

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
