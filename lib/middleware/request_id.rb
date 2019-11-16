# frozen_string_literal: true

module Middleware
  class RequestId
    def initialize(app, generator: -> { SecureRandom.base58 })
      @app = app
      @generator = generator
    end

    def call(env)
      request_id = @generator.call
      RequestStore.store[:request_id] = request_id

      @app.call(env).tap do |(_staus, headers, _body)|
        headers['X-Request-ID'] = request_id
      end
    end
  end
end
