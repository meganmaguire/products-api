require 'bcrypt'
require_relative '../models/user'

class UserStore
  class << self
    def init!
      @users = {}
      @next_id = 0
    end

    def seed(username:, password:)
      @next_id += 1
      @users[@next_id] = User.new(
        id: @next_id,
        username: username,
        password_digest: BCrypt::Password.create(password)
      )
    end

    def find_by_username(username)
      @users.values.find { |user| user.username == username }
    end
  end

  init!
end
