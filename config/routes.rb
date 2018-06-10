YourApplication::Application.routes.draw do
  mount API::Base => '/'

  mount GrapeSwaggerRails::Engine => '/docs'
  mount Sidekiq::Web => '/sidekiq'
end
