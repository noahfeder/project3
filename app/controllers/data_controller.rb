class DataController < ApplicationController
  include UsersHelper
  before_action :get_user, except: [:sound, :articles]

  def tweets
    fetch_global_trends
    if @user.woeid.nil?
      @local_trends = []
    else
      fetch_local_trends(@user)
    end
    @twitter = {global: @global_trends, local: @local_trends}
    render json: @twitter
  end

  def articles
    fetch_articles
    render json: @response
  end

  def weather
    fetch_weather
    render json: @results
  end

  def sound
    fetch_track
    @sound = {song_title: @song_title, scembed: @scembed}
    render json: @sound
  end

end
