module API
  class Base < Grape::API

    use Middleware::APILogger
    use Middleware::ErrorHandler

    prefix :api
    format :json

    helpers Support::Errors
    helpers Support::Helpers

    ####
    #
    # MOUNT YOUR API FILES HERE
    #
    ####

    add_swagger_documentation hide_format: true

    route [:get, :post, :put, :patch, :delete], '*path' do
      not_found! '404', 'API endpoint does not exist'
    end
  end
end
