require_dependency "railswiki/application_controller"

module Railswiki
  class UsersController < ApplicationController
    before_action :set_user, only: [:show, :edit, :update, :destroy]

    before_action :require_users_list_permission, only: [:index]
    before_action :require_user_edit_permission, only: [:edit, :update]
    before_action :require_user_delete_permission, only: [:destroy]

    # GET /users
    def index
      @users = User.all
    end

    # GET /users/1
    def show
      respond_to do |format|
        format.html
        format.json { render json: @user.expose_json }
      end
    end

    # GET /users/1/edit
    def edit
    end

    # PATCH/PUT /users/1
    def update
      if @user.update(user_params)
        redirect_to @user, notice: 'User was successfully updated.'
      else
        render :edit
      end
    end

    # DELETE /pages/1
    def destroy
      @user.destroy
      redirect_to users_url, notice: 'User was successfully destroyed.'
    end

    private

    # Use callbacks to share common setup or constraints between actions.
    def set_user
      @user = User.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def user_params
      params.require(:user).permit(:name, :email, :role)
    end
  end
end
