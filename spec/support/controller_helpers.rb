require "warden"

module ControllerHelpers
  # Builds a Rack env for a controller unit spec, with a stubbed Warden proxy
  # in place of the real Warden::Manager middleware. Controllers only ever
  # delegate to `warden`, so verifying that delegation is enough here -
  # Warden's own authentication behavior belongs to Warden's test suite.
  def env_for(path, method: "GET", params: {})
    env = Rack::MockRequest.env_for(path, method: method, params: params)
    env["warden"] = warden
    env
  end

  def warden
    @warden ||= instance_double(Warden::Proxy, authenticate!: true, reset_session!: true)
  end
end

RSpec.configure do |config|
  config.include ControllerHelpers, type: :controller
end
