require 'bcrypt'

class User
  attr_reader :id, :username, :password_digest

  def initialize(id:, username:, password_digest:)
    @id = id
    @username = username
    @password_digest = password_digest
  end

  def authenticate(password)
    BCrypt::Password.new(password_digest) == password
  end
end
