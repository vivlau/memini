class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def google_oauth2
    omniauth_data = request.env["omniauth.auth"].to_hash
    user = User.find_or_create_from_google_oauth2(omniauth_data)
    if user
      sign_in user
      redirect_to root_path, notice: "Welcome #{user.first_name}, successfully signed in with Google+"
    else
      redirect_to root_path, alert: "Sorry, unable to log in"
    end
  end
end
