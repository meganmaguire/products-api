require 'rack'
require 'json'
require 'byebug'

class BaseController
  def initialize(env, path_params = {})
    @env = env
    @request = Rack::Request.new(env)
    @path_params = path_params
  end

  private

  attr_reader :env, :request, :path_params

  def params
    @params ||= request.params.merge(path_params)
  end

  def warden
    env['warden']
  end

  def authenticate!
    warden.authenticate!
  end

  def unauthorized
    byebug
    render(401, { error: 'Unauthorized' })
  end

  def render(status, body_obj)
    [status, headers, [body_obj.to_json]]
  end

  def headers
    { 'content-type' => 'application/json' }
  end

  def job_response(id)
    { job_id: id, job_url: "http://localhost:3000/jobs/#{id}" }
  end
end
