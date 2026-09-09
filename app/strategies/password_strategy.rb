require 'warden'
require_relative '../stores/user_store'
require 'byebug'

class PasswordStrategy < Warden::Strategies::Base
  def valid?
    params['username'] && params['password']
  end

  def authenticate!
    valid_password? ? success!(user) : fail!('Invalid username or password')
  end

  def user
    @user ||= UserStore.find_by_username(params['username'])
  end

  private

  def valid_password?
    user && user.authenticate(params['password'])
  end
end

Warden::Strategies.add(:password, PasswordStrategy)
