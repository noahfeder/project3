module UsersHelper
  # cache trends for id=1 (Global) using redis
  # caches trends for 15 minutes (twitter updates every 5)
  def fetch_global_trends
    global_trends = $redis.get('global_trends')
    if global_trends.nil?
      response = twitter.trends(id = 1)
      global_trends = JSON.generate(response.attrs[:trends])
      $redis.set('global_trends', global_trends)
      $redis.expire('global_trends', 15.minutes.to_i)
    end
    @global_trends = JSON.load(global_trends)
  end


  # cache trends for given woeid using redis
  # caches trends for 15 minutes
  # @param woeid FixNum
  # TODO change param to be user or user location
  def fetch_local_trends(woeid)
    @woeid = woeid.to_i
    local_trends = $redis.get("local_trends_#{@woeid}")
    if local_trends.nil?
      response = twitter.trends(id = @woeid)
      local_trends = JSON.generate(response.attrs[:trends])
      $redis.set("local_trends_#{@woeid}", local_trends)
      $redis.expire("local_trends_#{@woeid}", 15.minutes.to_i)
    end
    @local_trends = JSON.load(local_trends)
  end

  def fetch_articles
    response = $redis.get('news')
    if response.nil?
      base_uri = "http://content.guardianapis.com/search?q=sortBy=popular"
      response = JSON.generate(HTTParty.get(base_uri+ "&api-key=" + ENV['GUARDIAN_API_KEY'])["response"]["results"])
      $redis.set("news", response)
      $redis.expire("news", 5.minutes.to_i)
    end
    @response = JSON.load(response)
  end

  def fetch_articles_by_topic(topic)
    #TODO search by params
  end

end
