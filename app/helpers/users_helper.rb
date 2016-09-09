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
  def fetch_local_trends(user)
    @woeid = user.woeid.to_i
    local_trends = $redis.get("local_trends_#{@woeid}")
    if local_trends.nil?
      response = twitter.trends(id = @woeid)
      local_trends = JSON.generate(response.attrs[:trends])
      $redis.set("local_trends_#{@woeid}", local_trends)
      $redis.expire("local_trends_#{@woeid}", 15.minutes.to_i)
    end
    @local_trends = JSON.load(local_trends)
  end

  # could probably be moved to articles_controller and be hit via AJAX?
  def fetch_articles
    response = $redis.get('news')
    if response.nil?
      base_uri = "http://content.guardianapis.com/search?order-by=newest"
      response = JSON.generate(HTTParty.get(base_uri + "&api-key=" + ENV['GUARDIAN_API_KEY'])["response"]["results"])
      $redis.set("news", response)
      $redis.expire("news", 5.minutes.to_i)
    end
    @response = JSON.load(response)
  end

  # works, but not implemented
  # could probably be moved to articles_controller and be hit via AJAX?
  def fetch_section(section)
    if guardian_sections.include? section
      response = $redis.get("news_#{section}")
      if response.nil?
        @section = "&section=" + section.to_s
        base_uri = "http://content.guardianapis.com/search?order-by=newest"
        response = JSON.generate(HTTParty.get(base_uri + @section + "&api-key=" + ENV['GUARDIAN_API_KEY'])["response"]["results"])
        $redis.set("news_#{section}", response)
        $redis.expire("news_#{section}", 5.minutes.to_i)
      end
      @response = JSON.load(response)
    else
      fetch_articles
    end
  end

  def guardian_sections
    @sections = ["artanddesign","australia-news","books","business","culture","education","environment","fashion","film","football","law","lifeandstyle","media","money","music","news","politics","science","society","sport","stage","technology","travel","uk-news","us-news","weather","world"]
  end

  def get_location
      @ip = request.remote_ip
      @ll = Geocoder.coordinates(@ip)
      @lat = @ll[0]
      @long = @ll[1]
      @woeid = twitter.trends_closest(lat: @lat, long: @long)[0].id # TODO preference storing id on signup
  end

  def fetch_weather
    lat = @user.lat.to_i || 40
    lng = @user.lng.to_i || -70
    results = $redis.get("weather_#{lat}_#{lng}")
    if results.nil?
      base_uri = "http://api.openweathermap.org/data/2.5/weather?lat=#{lat}&lon=#{lng}&units=imperial"
      results = JSON.generate(HTTParty.get(base_uri+ "&APPID=" + ENV['WEATHER_API_KEY']))
      $redis.set("weather_#{lat}_#{lng}",results)
      $redis.expire("weather_#{lat}_#{lng}",2.hours.to_i)
    end
    @results = JSON.load(results)
  end

  def fetch_track
    difgenres = ["Soundtrack","Ambient", "Trap"]
    randgenre = difgenres.sample
    client = SoundCloud.new(:client_id => ENV['SOUNDCLOUD_CLIENT_ID'])
    @track = client.get('/tracks', :limit => 1, :order => 'hotness', :genres => randgenre)
    @uri = @track.parsed_response[0]["uri"]
    embed_info = client.get('/oembed', :url => @uri)
    @scembed = embed_info.parsed_response["html"]
    @scembed.sub!("show_artwork=true","show_artwork=false")
    @scembed.sub!("visual=true","visual=false")
  end

end
