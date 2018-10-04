# TODO: change name to application name
YourApplication::Application.routes.draw do
  mount API::Base => '/'

  mount GrapeSwaggerRails::Engine => '/docs'
  mount Sidekiq::Web => '/sidekiq'

  post '/graphql', to: 'graphql#execute'
end
