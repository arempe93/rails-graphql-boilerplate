ruby '2.6.2'
source 'https://rubygems.org'

gem 'rails', '= 6.0.2'

# API Helpers
gem 'request_store'

# Rack CORS
gem 'rack-cors', require: 'rack/cors'

# Graphql
gem 'graphql'
gem 'graphql-batch'
gem 'graphiql-rails'

# Enums
gem 'enumerate_it'

# Global configs
gem 'global'

# Database
gem 'mysql2', '~> 0.5'

# Authentication
gem 'bcrypt'
gem 'jwt'

# Background Jobs
gem 'redis'
gem 'sidekiq'
gem 'sinatra', require: false

group :development, :test do
  # Linting
  gem 'rubocop'

  # Testing
  gem 'rspec'
  gem 'rack-test'

  # Environment bootstrap
  gem 'dotenv-rails'

  # Spring
  gem 'spring'

  # Model Annotations
  gem 'annotate'

  # Seeding information
  gem 'faker'

  # Autoloader filewatching
  gem 'listen', '>= 3.0.5', '< 3.2'
end

group :test do
  # Model factories
  gem 'factory_bot'

  # Database transaction cleaning
  gem 'database_cleaner'
end
