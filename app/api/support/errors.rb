# frozen_string_literal: true

module API
  module Support
    module Errors
      def respond_with_error!(status, message)
        payload = case message
                  when String then { message: message }
                  when Hash then message
                  else { message: 'An error occurred' }
                  end

        error!(payload, status)
      end

      def bad_request!(message = 'Bad Request')
        respond_with_error!(400, message)
      end

      def unauthorized!(message = 'Unauthorized')
        respond_with_error!(401, message)
      end

      def payment_required!(message = 'Payment Required')
        respond_with_error!(402, message)
      end

      def forbidden!(message = 'Forbidden')
        respond_with_error!(403, message)
      end

      def not_found!(message = 'Not Found')
        respond_with_error!(404, message)
      end

      def not_allowed!(message = 'Not Allowed')
        respond_with_error!(405, message)
      end

      def conflict!(message = 'Conflict')
        respond_with_error!(409, message)
      end

      def gone!(message = 'Gone')
        respond_with_error!(410, message)
      end

      def unprocessable!(message = 'Unprocessable Entity')
        respond_with_error!(422, message)
      end

      def server_error!(message = 'Internal Server Error')
        respond_with_error!(500, message)
      end
    end
  end
end
