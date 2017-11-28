class GrapeFilterLogger
  def initialize(app)
    @app = app
  end

  def call(env)
    if env['PATH_INFO'] =~ %r{^/api}
      @app.call(env)
    else
      Rails::Rack::Logger.new(@app).call(env)
    end
  end
end
