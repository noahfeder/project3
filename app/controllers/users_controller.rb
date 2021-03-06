class UsersController < ApplicationController
  include UsersHelper
  protect_from_forgery with: :exception, only: [:create]
  before_action :get_user, only: [:index]

  def index
  end

  def new
    redirect_to root_path
  end

  def create
    # set params from form with strong params
    @user = User.new(user_params)
    # grab @lat, @long, @woeid from helper function via twitter
    get_location
    #add additional location information to new User
    @user.lat = @lat
    @user.lng = @long
    @user.woeid = @woeid
    respond_to do |format|
      if @user.save
        # set an encrypted cookie on the client browser called :user_id
        # value is the current session's user's id
        # expiration is 20 years from now
        # also set session id since that's how we check for active login
        session[:user_id] = @user.id
        cookies.encrypted[:user_id] = {
          value: @user.id,
          expires: 20.years.from_now
        }
        format.html { redirect_to root_url, notice: 'User was successfully created.' }
        format.json { render :index, status: :created }
      else
        format.html { redirect_to root_url }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    @user = User.find_by_id(params[:id])
    @user.update(fname: params[:fname])
    render json: {user: @user}
  end

  def destroy
    @user = User.find_by_id(params[:id])
    @user.destroy
    redirect_to "/signout"
  end

  private

  # Never trust parameters from the scary internet, only allow the white list through.
  def user_params
    params.require(:user).permit(:fname, :lname, :email, :password)
  end

end
