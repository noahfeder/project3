class UsersController < ApplicationController
  include UsersHelper
  before_action :set_user, only: [:show, :edit, :update, :destroy]
  def index
    fetch_local_trends(2380358) #TODO: Add lookup by User instead of woeid
    fetch_global_trends
    @todos = Todo.all
    @user = User.find_by_id(session[:user_id]) || User.new
    base_uri = "http://content.guardianapis.com/search?q=sortBy=popular"
    @response = HTTParty.get(base_uri+ "&api-key=" + ENV['GUARDIAN_API_KEY'])["response"]["results"]
  end

  def new
    redirect_to root_path
  end

  def create
    @user = User.new(user_params)

    respond_to do |format|
      if @user.save
        session[:user_id] = @user.id
        format.html { redirect_to root_url, notice: 'User was successfully created.' }
        format.json { render :index, status: :created }
      else
        format.html { render :new }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  def edit
    redirect_to "/"
  end

  def destroy
    redirect_to "/new"
  end

  private
    #get local and global trends for user
    #TODO Caching
    #def get_trends
      #@ip = "8.8.8.8" # TODO change to dynamic, based on request.remote_ip
      #@ll = Geocoder.coordinates(@ip) # TODO preference storing coordinates on signup
      #@tl = twitter.trends_closest(lat: @ll[0], long: @ll[1])[0].id # TODO preference storing id on signup
      #@local_trends = twitter.trends(id = @tl) #local trends, TODO add redis
      #@global_trends = twitter.trends(id = 1) #global trends, TODO add redis
    #end

  # Use callbacks to share common setup or constraints between actions.
  def set_user
    @user = User.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def user_params
    params.require(:user).permit(:fname, :lname, :email, :password)
  end

end
