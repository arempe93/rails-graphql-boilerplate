# frozen_string_literal: true

module API
  class Base < Grape::API
    insert_after Grape::Middleware::Formatter,
                 Grape::Middleware::Logger

    prefix :api
    format :json

    helpers Support::Errors
    helpers Support::Helpers

    rescue_from Grape::Exceptions::ValidationErrors do |e|
      bad_request!(message: 'Bad Request', errors: e.full_messages)
    end

    rescue_from :all { |e| server_error!(e.message) }

    mount Example

    add_swagger_documentation hide_format: true

    route %i[get post put patch delete], '*path' do
      not_found! 'API endpoint does not exist'
    end
  end
end
