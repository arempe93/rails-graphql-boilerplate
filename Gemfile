source 'https://rubygems.org'

gem 'rails', '~> 5.2'

# Grape API
gem 'grape'
gem 'grape-entity'

# API Helpers
gem 'request_store'

# Rack CORS
gem 'rack-cors', require: 'rack/cors'

# Swagger API doc
gem 'grape-swagger'
gem 'grape-swagger-rails'
gem 'grape-swagger-entity'

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
end

group :test do
  # Model factories
  gem 'factory_girl_rails', '= 4.8.0'

  # Database transaction cleaning
  gem 'database_cleaner'
end
