module UsersHelper

  def get_user
    if params["data"] && params["data"]["chrome"] == "true"
      get_chrome_user(params["data"]["auth"])
    else
      get_web_user
    end
  end

  def get_web_user
    session[:user_id] = cookies.encrypted[:user_id]
    @user = User.find_by_id(session[:user_id]) || User.new
  end

  def get_chrome_user(auth)
    puts auth
    @user = User.find_or_create_by_uid(auth)
  end

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
      base_uri = "http://content.guardianapis.com/search?order-by=newest&type=article"
      response = JSON.generate(HTTParty.get(base_uri + "&api-key=" + ENV['GUARDIAN_API_KEY'])["response"]["results"])
      $redis.set("news", response)
      $redis.expire("news", 1.hours.to_i)
    end
    @response = JSON.load(response)
  end

  def fetch_pics
     img = $redis.get('img')
     if img.nil?
      base = "http://api.unsplash.com/photos/random?orientation=landscape&featured=true&query=architecture"
      response = JSON.generate(HTTParty.get(base + "&client_id=" + ENV['UNSPLASH_APP_ID']))
      img = JSON.load(response)["urls"]["raw"]
      $redis.set('img', img)
      $redis.expire('img', 10.minutes.to_i)
     end
    @img = img
  end


  # works, but not implemented
  # could probably be moved to articles_controller and be hit via AJAX?
  def fetch_section(section)
    if guardian_sections.include? section
      response = $redis.get("news_#{section}")
      if response.nil?
        @section = "&section=" + section.to_s
        base_uri = "http://content.guardianapis.com/search?order-by=newest&type=article"
        response = JSON.generate(HTTParty.get(base_uri + @section + "&api-key=" + ENV['GUARDIAN_API_KEY'])["response"]["results"])
        $redis.set("news_#{section}", response)
        $redis.expire("news_#{section}", 1.hours.to_i)
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
    @genre = genre
    embed_info = $redis.get("sound_#{@genre}")
    unless embed_info.nil?
      # Major help from http://stackoverflow.com/questions/35688367/access-soundcloud-charts-with-api
      req = "https://api-v2.soundcloud.com/charts?kind=trending&genre=soundcloud:genres:#{@genre}&limit=10&linked_partitioning=1&client_id=" + ENV["SOUNDCLOUD_CLIENT_ID"]
      track = JSON.parse JSON.generate HTTParty.get(req)
      # I'M SORRY SANDI
      if track
        if track["collection"]
          if track["collection"][0]
            if track["collection"][0]["track"]
              if track["collection"][0]["track"]["permalink_url"]
                uri = track["collection"][0]["track"]["permalink_url"]
                client = Soundcloud.new(:client_id => ENV['SOUNDCLOUD_CLIENT_ID'])
                embed_info = client.get('/oembed', :url => uri)
                @sound = Sound.find_by_genre(@genre) || Sound.create(genre: @genre)
                @sound.update(embed_info: JSON.generate(embed_info))
                embed_info = @sound.embed_info
                $redis.set("sound_#{@genre}", embed_info)
                $redis.expire("sound_#{@genre}", 8.hours.to_i)
              end
            end
          end
        end
      else
        embed_info = JSON.generate({title: "", html: ""})
      end
    end
    @embed_info = JSON.load(embed_info)
    if @embed_info.nil?
      @song_title = ""
      @scembed = ""
    else
      @song_title = @embed_info["title"]
      @scembed = @embed_info["html"].sub!("show_artwork=true","show_artwork=false").sub!("visual=true","visual=false").html_safe
    end
  end

  def genre
    ["danceedm","hiphoprap","ambient","trap","jazz"].sample
  end

end
