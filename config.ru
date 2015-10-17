require 'dotenv'
require 'sidekiq'
require 'sidekiq/web'
require 'split/dashboard'

Dotenv.load

Sidekiq.configure_client do |config|
  config.redis = { url: ENV['REDIS_URL'] }
end

redis_uri = URI.parse(ENV['REDIS_URL'])
Split.redis = Redis.new(
  host: redis_uri.host,
  port: redis_uri.port,
  password: redis_uri.password,
  username: redis_uri.user
)

use Rack::Auth::Basic, "Protected Area" do |username, password|
  username == ENV['USERNAME'] && password == ENV['PASSWORD']
end

run Rack::URLMap.new \
  '/sidekiq' => Sidekiq::Web.new,
  '/split' => Split::Dashboard.new
