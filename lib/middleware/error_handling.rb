# frozen_string_literal: true

module Middleware
  module ErrorHandling
    def call_with_error_handling
      response = nil
      error = catch(:error) do
        nil.tap { response = @app.call(@env) }
      end

      if error
        yield(error)
        throw :error, error
      end

      response
    end
  end
end
