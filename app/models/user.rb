# == Schema Information
#
# Table name: users
#
#  id              :integer          not null, primary key
#  email           :string
#  password_digest :string
#  lat             :string
#  lng             :string
#  woeid           :string
#  fname           :string
#  lname           :string
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#

class User < ApplicationRecord
  # MAGIC BCRYPT MAGIC
  has_secure_password
  # destroy cascades to user's todos
  has_many :todos, :dependent => :destroy

  # Lookup location by lat and lng
  reverse_geocoded_by :lat, :lng, address: :location
  after_validation :reverse_geocode

  # Simple validations
  validates :password, length: {minimum: 2,
    message: "Password too short"}, on: :create
  validates :email, uniqueness: true, on: :create
  validates :fname, presence: true
  validates :email, format: {with: /\A([\w+\-].?)+@[a-z\d\-]+(\.[a-z]+)*\.[a-z]+\z/i,
    message: "Invalid Email"}

  def self.find_or_create_by_uid(auth)
    @user = User.find_by_uid(auth["id"])
    puts @user
    if @user.nil?
      @user = User.new
      @user.uid = auth["id"]
      @user.email = auth["email"]
      @user.fname = auth["given_name"]
      @user.lname = auth["family_name"]
      @user.password = "password"
      @user.lat = auth["latitude"].to_f
      @user.lng = auth["longitude"].to_f
      twitter = Twitter::REST::Client.new do |config|
        config.consumer_key        = ENV["TWITTER_CONSUMER_KEY"]
        config.consumer_secret     = ENV["TWITTER_CONSUMER_SECRET"]
        config.access_token        = ENV["TWITTER_ACCESS_TOKEN"]
        config.access_token_secret = ENV["TWITTER_ACCESS_SECRET"]
      end
      @user.woeid = twitter.trends_closest(lat: @user.lat, long: @user.lng)[0].id
      @user.save
    end
    @user
  end

end
