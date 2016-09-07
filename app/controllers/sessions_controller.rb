class SessionsController < ApplicationController
  def create
    u = params[:email]
    p = params[:password]
    user = User.find_by_email(u).try(:authenticate, p)
    if user.nil?
      redirect_to root_path
    else
      session[:user_id] = user.id
      redirect_to root_path
    end
  end

  def destroy
    session[:user_id] = nil
    redirect_to root_path
  end
end
