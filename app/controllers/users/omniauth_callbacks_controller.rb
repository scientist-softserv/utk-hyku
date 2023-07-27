class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
    skip_before_action :verify_authenticity_token, only: [:cas, :developer]

    def cas
      # You need to implement the method below in your model (e.g. app/models/user.rb)
      @user = User.find_for_cas(request.env["omniauth.auth"])

      if @user.persisted?
        sign_in_and_redirect @user, event: :authentication # this will throw if @user is not activated
        set_flash_message(:notice, :success, kind: "CAS") if is_navigational_format?
      else
        session["devise.cas_data"] = request.env["omniauth.auth"].except(:extra) # Removing extra as it can overflow some session stores
        redirect_to new_user_registration_url
      end
    end

    def failure
      redirect_to root_path
    end

    def developer
      if Rails.env.production?
        redirect_to root_path
      else
        @user = User.find_for_developer(request.env["omniauth.auth"])

        if @user.persisted?
          sign_in_and_redirect @user, event: :authentication # this will throw if @user is not activated
          set_flash_message(:notice, :success, kind: "DEVELOPER") if is_navigational_format?
        else
          session["devise.developer_data"] = request.env["omniauth.auth"].except(:extra) # Removing extra as it can overflow some session stores
          redirect_to new_user_registration_url
        end
      end
    end
end
