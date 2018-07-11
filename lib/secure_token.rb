# frozen_string_literal: true

class SecureToken
  SECRET = Rails.application.secrets.secret_key_base

  class << self
    def decode!(jwt)
      payload_section = jwt.split('.').second
      JSON.parse(Base64.decode64(payload_section), symbolize_names: true)
    end

    def decode(jwt)
      decode!(jwt)
    rescue NoMethodError, JSON::ParserError
      nil
    end

    def validate!(token)
      payload, _header = JWT.decode(token, SECRET)
      payload.deep_symbolize_keys
    end

    def validate(token)
      validate!(token)
    rescue JWT::DecodeError
      nil
    end
  end

  attr_accessor :iss, :iat, :sub, :jti, :exp, :claims
  attr_reader :encoded

  delegate :[], to: :claims

  def initialize(sub:, exp: Global.jwt.expiration, **opts)
    @iss = Global.jwt.issuer
    @sub = sub
    @jti = SecureRandom.base58
    @exp = (Time.now + exp).to_i

    @claims = opts
    @claims[:iss] = @iss
    @claims[:sub] = @sub
    @claims[:jti] = @jti
    @claims[:exp] = @exp
  end

  def to_s
    @to_s ||= JWT.encode(@claims, SECRET, Global.jwt.algorithm)
  end
end
