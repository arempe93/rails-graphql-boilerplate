module Middleware
  class ErrorHandler < Grape::Middleware::Base
    def call!(env)
      @env = env

      begin
        @app.call @env

      rescue => e

        # let grape handle param validation errors
        raise e if e.is_a?(Grape::Exceptions::ValidationErrors)
        
        Rails.logger.error "API ERROR: #{e.message}"
        Rails.logger.error "API ERROR: #{e.backtrace.join("\n\t")}"

        # rescue from uncaught api exceptions
        catch_error(e)
      end
    end

    private

    def catch_error(e)
      response = {
        code: '500',
        message: e.message
        backtrace: e.backtrace
      }

      [ 500, { 'Content-Type' => 'application/json' }, [ response.to_json ] ]
    end
  end
end