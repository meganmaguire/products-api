require_relative 'base_controller'
require 'byebug'

class SessionsController < BaseController
  def create
    warden.reset_session!
    authenticate!
    render(200, { message: 'Successful log in' })
  end
end
