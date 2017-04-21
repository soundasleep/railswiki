require_dependency "railswiki/application_controller"

module Railswiki
  class HistoriesController < ApplicationController
    before_action :set_history, only: [:show, :destroy]

    before_action :require_histories_list_permission, only: [:index]
    before_action :require_history_delete_permission, only: [:destroy]

    # GET /histories
    def index
      @histories = History.all
    end

    # GET /histories/1
    def show
      respond_to do |format|
        format.html
        format.json { render json: @history.expose_json }
      end
    end

    # DELETE /histories/1
    def destroy
      @history.destroy
      @history.page.reload

      latest_version = @history.page.histories.order(created_at: :desc).first
      @history.page.update_attributes!({
        latest_version_id: latest_version.present? ? latest_version.id : nil,
      })

      redirect_to @history.page, notice: 'History was successfully destroyed.'
    end

    private

    # Use callbacks to share common setup or constraints between actions.
    def set_history
      @history = History.find(params[:id])
    end
  end
end
