require 'dotenv'
require 'sidekiq'
require 'sidekiq/web'

Dotenv.load

Sidekiq.configure_client do |config|
  config.redis = { url: ENV['REDIS_URL'] }
end

use Rack::Auth::Basic, "Protected Area" do |username, password|
  username == ENV['USERNAME'] && password == ENV['PASSWORD']
end

run Sidekiq::Web
