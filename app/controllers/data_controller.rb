class DataController < ApplicationController
  include UsersHelper
  before_action :get_user, except: [:sound, :articles]

  def index
    fetch_pics
    fetch_global_trends
    if @user.woeid.nil?
      @local_trends = []
    else
      fetch_local_trends(@user)
    end
    fetch_articles
    fetch_track
    fetch_weather
    @data = {
      twitter: {
        global: @global_trends,
        local: @local_trends
      },
      articles: @response,
      sound: {
        song_title: @song_title,
        scembed: @scembed
      },
      weather: @results,
      todos: @user.todos,
      name: @user.fname,
      id: @user.id
    }
    render json: @data
  end

  def pics
    fetch_pics
      @pic = {pics: @backImg}
    render json: @pic
  end


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
