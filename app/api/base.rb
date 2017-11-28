module API
  class Base < Grape::API
    insert_after Grape::Middleware::Formatter,
                 Grape::Middleware::Logger

    use Middleware::ErrorHandler

    prefix :api
    format :json

    helpers Support::Errors
    helpers Support::Helpers

    mount Example

    add_swagger_documentation hide_format: true

    route %i[get post put patch delete], '*path' do
      not_found! 'API endpoint does not exist'
    end
  end
end
