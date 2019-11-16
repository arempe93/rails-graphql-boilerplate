# TODO: change name to application name
YourApplication::Application.routes.draw do
  mount Sidekiq::Web => '/sidekiq'

  post '/graphql', to: 'graphql#execute'
end
