class JsonWebToken
  def self.encode(payload, exp = 24.hours.from_now)
    payload[:exp] = exp.to_i
    JWT.encode(payload, ENV["SECRET_KEY"])
  end

  def self.decode(token)
    decoded = JWT.decode(token, ENV["SECRET_KEY"])[0]
    HashWithIndifferentAccess.new decoded
  end

  def self.login_token_encode(object)
    expiry = 1.week.from_now
    hash = BCrypt::Password.create(SecureRandom.hex(10))
    token = JWT.encode((hash + Time.now.to_s), ENV["SECRET_KEY"])
    auth_key = AuthToken.find_or_create_by(user: object)
    auth_key.update!(token: token, expiry: expiry)
    auth_key.token
  end
end
