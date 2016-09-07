class ArticlesController < ApplicationController

  def index
      base_uri = "http://content.guardianapis.com/search?q=sortBy=popular"
      @response = HTTParty.get(base_uri+ "&api-key=" + ENV['GUARDIAN_KEY'])["response"]["results"]
      puts @response
      @response
  end

  def api_key
    ENV['GUARDIAN_KEY']
  end

  def show
  ##  response = ("/", sortBy=popular)
    puts response
    end

end

