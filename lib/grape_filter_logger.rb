# frozen_string_literal: true

class GrapeFilterLogger
  def initialize(app)
    @app = app
  end

  def call(env)
    if %r{^/api}.match?(env['PATH_INFO'])
      @app.call(env)
    else
      Rails::Rack::Logger.new(@app).call(env)
    end
  end
end
