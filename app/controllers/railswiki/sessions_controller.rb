require_dependency "railswiki/application_controller"

module Railswiki
  class SessionsController < ApplicationController
    def create
      auth = request.env["omniauth.auth"]
      user = User.where(:provider => auth["provider"], :uid => auth["uid"]).first_or_initialize(
        :refresh_token => auth["credentials"]["refresh_token"],
        :access_token => auth["credentials"]["token"],
        :expires => auth["credentials"]["expires_at"],
        :name => auth["info"]["name"],
        :email => auth["info"]["email"],
        :image_url => auth["info"]["image"],
      )
      url = session[:return_to] || root_path
      session[:return_to] = nil
      url = root_path if url.eql?('/logout')

      if user.save
        session[:user_id] = user.id
        user.update_attributes! last_login: Time.now
        notice = "Signed in!"

        if User.count == 1
          user.update_attributes! role: "admin"
          notice += " You have been automatically assigned admin privileges."
        end

        redirect_to url, :notice => notice
      else
        raise "Failed to login"
      end
    end

    def destroy
      session[:user_id] = nil
      redirect_to root_url, :notice => "Signed out!"
    end
  end
end
