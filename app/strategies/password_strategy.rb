require "warden"
require_relative "../stores/user_store"
require 'byebug'

class PasswordStrategy < Warden::Strategies::Base
  def valid?
    params["username"] && params["password"]
  end

  def authenticate!
    user = UserStore.find_by_username(params["username"])
    if user && user.authenticate(params["password"])
      success!(user)
    else
      fail!("Invalid username or password")
    end
  end
end

Warden::Strategies.add(:password, PasswordStrategy)
