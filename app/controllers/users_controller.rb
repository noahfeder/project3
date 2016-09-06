class UsersController < ApplicationController
  before_action :get_trends, only: [:index]
  def index
  end

  def new
    redirect_to "/"
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
    def get_trends
      #@ip = "8.8.8.8" # TODO change to dynamic, based on request.remote_ip
      #@ll = Geocoder.coordinates(@ip) # TODO preference storing coordinates on signup
      #@tl = twitter.trends_closest(lat: @ll[0], long: @ll[1])[0].id # TODO preference storing id on signup
      #@local_trends = twitter.trends(id = @tl) #local trends, TODO add redis
      #@global_trends = twitter.trends(id = 1) #global trends, TODO add redis
    end
end
