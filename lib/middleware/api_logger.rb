module Middleware
  class APILogger < Grape::Middleware::Base
    
    def before

      request_method = env['REQUEST_METHOD']

      Rails.logger.info "REQUEST METHOD:\t#{request_method}"
      Rails.logger.info "REQUEST PATH:\t#{env['REQUEST_PATH']}"
      Rails.logger.info "QUERY STRING:\t#{env['QUERY_STRING']}" unless request_method == 'POST'
      Rails.logger.info "POST PARAMS:\t#{env['rack.request.form_hash']}" if request_method == 'POST'
    end

  end
end