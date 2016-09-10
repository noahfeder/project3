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
end
