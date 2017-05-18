require_dependency "railswiki/application_controller"

module Railswiki
  class InvitesController < ApplicationController
    include ApplicationHelper

    before_action :set_invite, only: [:show, :destroy]
    before_action :require_invites_list_permission, only: [:index]
    before_action :require_invite_create_permission, only: [:new, :create]
    before_action :require_invite_delete_permission, only: [:destroy]

    # GET /invites
    def index
      @invites = Invite.all
    end

    # GET /invites/1
    def show
      respond_to do |format|
        format.html
      end
    end

    # GET /invites/new
    def new
      @invite = Invite.new
      @invite.inviting_user = current_user
      @invite.role = User::ROLE_EDITOR
    end

    # POST /invites
    def create
      @invite = Invite.new(invite_params)
      @invite.inviting_user = current_user

      if @invite.save
        redirect_to @invite, notice: 'Invite was successfully created.'
      else
        render :new
      end
    end

    # DELETE /invites/1
    def destroy
      @invite.destroy
      redirect_to invites_url, notice: 'Invite was successfully destroyed.'
    end

    private

    # Use callbacks to share common setup or constraints between actions.
    def set_invite
      @invite = Invite.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def invite_params
      params.require(:invite).permit(:email, :role)
    end
  end
end
