# frozen_string_literal: true

module AuthenticationService
  KEY_PREFIX = 'tokens:user:'

  RefreshTokenNotFound = Class.new(StandardError)

  module_function

  def deauthorize(user_id)
    Device.where(user_id: user_id).update_all(expires_at: 0)
    revoke_all(user_id)
  end

  def issue(user, attrs = {})
    attrs[:last_issued] = SecureRandom.base58
    device = user.devices.create!(attrs)

    token = SecureToken.new(sub: user.id,
                            jti: attrs[:last_issued],
                            d: device.id)
    add_to_whitelist(token)

    [device, token]
  end

  def refresh(device, attrs = {})
    SecureToken.new(sub: device.user_id, d: device.id).tap do |token|
      add_to_whitelist(token)
      device.refresh!(jti: token.jti, **attrs)
    end
  end

  def revoke(user_id, jti:)
    Redis.current.zrem("#{KEY_PREFIX}#{user_id}", jti)
  end

  def revoke_all(user_id)
    Redis.current.del("#{KEY_PREFIX}#{user_id}")
  end

  def verify(jwt)
    SecureToken.validate!(jwt).tap do |token|
      return nil unless whitelisted?(token)
    end
  rescue JWT::DecodeError
    nil
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

    Redis.current.zscore(key, token[:jti]) > Time.now.to_i
  end
  private_class_method :whitelisted?
end
