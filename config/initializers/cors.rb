Rails.application.config.middleware.use Rack::Cors do
  allow do
    origins '*'
    resource '/api/*', headers: :any, methods: %i[get post put patch delete options]
  end
end
