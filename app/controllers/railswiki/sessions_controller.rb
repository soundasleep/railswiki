require_dependency "railswiki/application_controller"

module Railswiki
  class SessionsController < ApplicationController
    def create
      User.transaction do
        notice = []

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

        if user.new_record?
          if User.count == 0
            user.role = User::ROLE_ADMIN
            notice << "As the first user, you have been automatically assigned admin privileges."
          else
            # this user must have been invited
            invite = find_invite(user)
            if invite
              user.role = invite.role
              user.save!
              invite.update_attributes!({
                invited_user: user,
                accepted_at: Time.now,
              })

              notice << "Invite accepted as a #{invite.role || "user"}."
            else
              return redirect_to sessions_no_invite_path
            end
          end
        end

        if user.save
          session[:user_id] = user.id
          user.update_attributes! last_login: Time.now
          notice << "Signed in!"

          redirect_to url, :notice => notice.join("\n")
        else
          raise "Failed to login: #{user.errors.full_messages.join(", ")}"
        end
      end
    end

    def not_authorized
      render status: :unauthorized
    end

    def no_invite
      render status: :forbidden
    end

    def destroy
      session[:user_id] = nil
      redirect_to root_url, :notice => "Signed out!"
    end

    private

    def find_invite(user)
      Invite.where(email: user.email, accepted_at: nil).first
    end
  end
end
