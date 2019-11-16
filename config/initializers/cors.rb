Rails.application.config.middleware.use Rack::Cors do
  allow do
    origins '*'
    resource '/graphql', headers: :any,
                         methods: %i[get post options]
  end
end
