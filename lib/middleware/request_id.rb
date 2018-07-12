# frozen_string_literal: true

module Middleware
  class RequestId < Grape::Middleware::Base
    include ErrorHandling

    def initialize(app, generator: -> { SecureRandom.base58 })
      @app = app
      @generator = generator
    end

    def call!(env)
      @env = env
      request_id = @generator.call

      RequestStore.store[:request_id] = request_id

      response = call_with_error_handling do |error|
        error[:headers] ||= {}
        error[:headers]['X-Request-ID'] = request_id
      end

      response.tap do |(_staus, headers, _body)|
        headers['X-Request-ID'] = request_id
      end
    end
  end
end
