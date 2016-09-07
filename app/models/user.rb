class User < ApplicationRecord

has_many :todos

  def self.from_omniauth(auth)
    find_by_provider_uid(auth['provider'], auth['uid']) || create_with_omniauth(auth)
  end

  def self.create_with_omniauth(auth)
    create do |user|
      user.provider = auth['provider']
      user.id = auth['uid']
      user.name = auth['info']['name']
    end
  end
end
