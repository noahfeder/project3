require_relative 'boot'

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Project3
  class Application < Rails::Application
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.
    config.cache_store = :redis_store, ENV["REDIS_URL"], { expires_in: 90.minutes}

    config.middleware.insert_before 0, Rack::Cors do
      allow do
        origins '*' #TODO LIMIT TO CHROME EX
        resource '*', :headers => :any, :methods => :any
      end
    end

  end
end
