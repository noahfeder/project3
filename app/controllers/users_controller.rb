class UsersController < ApplicationController
  include UsersHelper
  def index
    # check for encrypted user cookie to set session id
    session[:user_id] = cookies.encrypted[:user_id]
    @user = User.find_by_id(session[:user_id]) || User.new
    fetch_global_trends #returns @global_trends
    # get current user's todo list items
    @todos = Todo.where(user_id: session[:user_id])

    # client = "https://api.soundcloud.com/tracks?client_id="
    # @tracks = JSON.generate(HTTParty.get(client + ENV['SOUNDCLOUD_CLIENT_ID']))#["tracks"]
    # @tracks = JSON.parse(@tracks)[0]
    # @tracks.each do |track|
    #   print track["stream_url"]
    # end


    difgenres = ["Soundtrack","Ambient", "Trap"]
    randgenre = difgenres.sample
    client = SoundCloud.new(:client_id => ENV['SOUNDCLOUD_CLIENT_ID'])
    @track = client.get('/tracks', :limit => 1, :order => 'hotness', :genres => randgenre)
    @uri = @track.parsed_response[0]["uri"]
    embed_info = client.get('/oembed', :url => @uri)
    @scembed = embed_info.parsed_response["html"]
    @scembed.sub!("show_artwork=true","show_artwork=false")
    @scembed.sub!("visual=true","visual=false")
    puts randgenre
    # byebug
    #@stream_url = @tracks.parsed_response[0]["stream_url"]
    #@stream_url = client.get(@track.stream_url, :allow_redirects => true)

    # @tracks.each do |track|
    #   print track["stream_url"]
    # end

    if !@user.woeid.nil?
      fetch_local_trends(@user)
    end
    fetch_articles
    fetch_weather
  end

  def new
    redirect_to root_path
  end

  def create
    # set params from form with strong params
    @user = User.new(user_params)
    # grab @lat, @long, @woeid from helper function via twitter
    get_location
    #add additional location information to new User
    @user.lat = @lat
    @user.lng = @long
    @user.woeid = @woeid
    respond_to do |format|
      if @user.save
        # set an encrypted cookie on the client browser called :user_id
        # value is the current session's user's id
        # expiration is 20 years from now
        # also set session id since that's how we check for active login
        session[:user_id] = @user.id
        cookies.encrypted[:user_id] = {
          value: @user.id,
          expires: 20.years.from_now
        }
        format.html { redirect_to root_url, notice: 'User was successfully created.' }
        format.json { render :index, status: :created }
      else
        format.html { redirect_to root_url }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    # TODO add update
  end

  def destroy
    @user = User.find_by_id(params[:id])
    @user.destroy
    redirect_to "/signout"
  end

  private

  # Never trust parameters from the scary internet, only allow the white list through.
  def user_params
    params.require(:user).permit(:fname, :lname, :email, :password)
  end

end
