require File.expand_path('../boot', __FILE__)

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module YourApplication
  class Application < Rails::Application
    # Load Grape API and enumerations
    config.paths.add 'app/api', glob: '**/*.rb'
    config.paths.add 'app/enums', glob: '**/*.rb'
    config.autoload_paths += Dir["#{Rails.root}/app"]

    # Load lib
    config.autoload_paths << Rails.root.join('lib')
  end
end
