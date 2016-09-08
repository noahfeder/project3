class WeathersController < ApplicationController

    def index
      base_uri = "http://api.openweathermap.org/data/2.5/weather?lat=40&lon=-70"

      @results = HTTParty.get(base_uri+ "&APPID=" + ENV['WEATHER_API_KEY']+ "&units=imperial")

      puts @results
      @results
    end

    def key
    ENV['WEATHER_API_KEY']
    end


end
