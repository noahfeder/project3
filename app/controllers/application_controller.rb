class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  # Gives access to the twitter API by calling twitter#method
  # e.g.: @trends = twitter.trends(id = 1) returns all global trends
  def twitter
    twitter = Twitter::REST::Client.new do |config|
      config.consumer_key        = ENV["TWITTER_CONSUMER_KEY"]
      config.consumer_secret     = ENV["TWITTER_CONSUMER_SECRET"]
      config.access_token        = ENV["TWITTER_ACCESS_TOKEN"]
      config.access_token_secret = ENV["TWITTER_ACCESS_SECRET"]
    end
  end

end
