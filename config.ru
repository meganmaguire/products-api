require_relative 'app/app'
require 'rack/session'
require 'warden'
require 'rack/contrib/json_body_parser'

app = Rack::Builder.new do
  use Rack::Lint if ENV["RACK_LINT"]
  use Rack::JSONBodyParser
  use Rack::CommonLogger
  use Rack::Deflater
  use Rack::Static,
    urls: ['/AUTHORS'], root: __dir__,
    header_rules: [[:all, { 'cache-control' => 'public, max-age=86400' }]]
  use Rack::Static,  urls: ['/openapi.yml'], root: __dir__
  use Rack::Session::Cookie, secret: ENV.fetch('SESSION_SECRET', 'a' * 64)
  use Warden::Manager do |manager|
    manager.default_strategies :password
    manager.failure_app = Proc.new do |env|
      message = env['warden.options'][:message] || 'Unauthorized'
      [401, { 'content-type' => 'application/json' }, [{ error: message }.to_json]]
    end
    manager.serialize_into_session { |user| user.username }
    manager.serialize_from_session { |username| UserStore.find_by_username(username) }
  end

  run App.new
end

run app