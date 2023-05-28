class JsonWebToken
  SECRET_KEY = "44f84291c4c801ee6b844b7b6c54538b312edccfefa48d01f201f14aeab5c58ced9fe82d29b61e0ed7261922763b17c63910794ed2243fb4da66136c7c1cd89c"

  def self.encode(payload, exp = 24.hours.from_now)
    payload[:exp] = exp.to_i
    JWT.encode(payload, SECRET_KEY)
  end

  def self.decode(token)
    decoded = JWT.decode(token, SECRET_KEY)[0]
    HashWithIndifferentAccess.new decoded
  end
end
