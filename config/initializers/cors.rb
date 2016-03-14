Rails.application.config.middleware.use Rack::Cors do
  allow do
    origins '*'
    resource '/api/*', headers: :any, methods:  [ :get, :post, :options, :put ]
  end
end