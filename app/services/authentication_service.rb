# frozen_string_literal: true

module AuthenticationService
  KEY_PREFIX = 'tokens:user:'

  module_function

  def deauthorize(user_id)
    Redis.current.del("#{KEY_PREFIX}#{user_id}")
  end

  def tokenize(user)
    SecureToken.new(sub: user.id).tap do |token|
      add_to_whitelist(token)
    end
  end

  def verify(jwt)
    SecureToken.validate(jwt).tap do |token|
      return nil unless token
      return nil unless whitelisted?(token)
    end
  end

  ## private ##

  def add_to_whitelist(token)
    key = "#{KEY_PREFIX}#{token.sub}"

    Redis.current.multi do
      Redis.current.zadd(key, token.exp, token.jti)
      Redis.current.zremrangebyscore(key, '-inf', "(#{Time.now.to_i}")
      Redis.current.expireat(key, token.exp)
    end
  end
  private_class_method :add_to_whitelist

  def whitelisted?(token)
    key = "#{KEY_PREFIX}#{token[:sub]}"

    Redis.current.zscore(key, token[:jti]).present?
  end
  private_class_method :whitelisted?
end
