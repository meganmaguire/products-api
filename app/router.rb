require "rack"
require "json"
require_relative 'controllers/base_controller'

class Router
  Route = Struct.new(:verb, :pattern, :param_names, :controller_class, :action)

  def initialize
    @routes = []
  end

  def add(verb, path, controller_class, action)
    pattern, param_names = parse_path(path)
    @routes << Route.new(verb.to_s.upcase, pattern, param_names, controller_class, action)
  end

  def call(env)
    request = Rack::Request.new(env)
    match_data = nil
    route = @routes.find do |r|
      next false unless r.verb == request.request_method
      match_data = r.pattern.match(request.path_info)
    end
    return not_found unless route && match_data

    path_params = route.param_names.zip(match_data.captures).to_h
    controller = route.controller_class.new(env, path_params)
    controller.public_send(route.action)
  end

  private

  def parse_path(path)
    param_names = []
    segments = path.split("/").map do |segment|
      if segment.start_with?(":")
        param_names << segment[1..]
        "([^/]+)"
      else
        Regexp.escape(segment)
      end
    end
    pattern = segments.join("/")
    pattern = "/" if pattern.empty?
    [Regexp.new("\\A#{pattern}\\z"), param_names]
  end

  def not_found
    [404, { "content-type" => "application/json" }, [{ error: "Service not found" }.to_json]]
  end
end
