class SessionsController < ApplicationController
  def create
    email = params[:email]
    password = params[:password]
    user = User.find_by_email(email).try(:authenticate, password)
    if user.nil? || user == false
      redirect_to root_path
    else
      # set an encrypted cookie on the client browser called :user_id
      # value is the current session's user's id
      # expiration is 20 years from now
      # also set session id since that's how we check for active login
      cookies.encrypted[:user_id] = {
        value: user.id,
        expires: 20.years.from_now
      }
      session[:user_id] = user.id
      #send back home
      redirect_to root_path
    end
  end

  def destroy
    # on logout, destroy cookie (NOT just set to nil)
    # also set session user_id to nil
    session[:user_id] = nil
    cookies.delete(:user_id)
    #send back home
    redirect_to root_path
  end
end
