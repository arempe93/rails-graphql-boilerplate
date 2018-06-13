# frozen_string_literal: true

module API
  module Support
    module Errors
      def respond_with_error!(status, message, code)
        payload = { code: code.to_s }
        payload.merge!(message.is_a?(String) ? { message: message } : message)

        error!(payload, status)
      end

      def bad_request!(message, code: '400')
        respond_with_error!(400, message || 'Bad Request', code)
      end

      def unauthorized!(message, code: '401')
        respond_with_error!(401, message || 'Unauthorized', code)
      end

      def payment_required!(message, code: '402')
        respond_with_error!(402, message || 'Payment Required', code)
      end

      def forbidden!(message, code: '403')
        respond_with_error!(403, message || 'Forbidden', code)
      end

      def not_found!(message, code: '404')
        respond_with_error!(404, message || 'Not Found', code)
      end

      def not_allowed!(message, code: '405')
        respond_with_error!(405, message || 'Not Allowed', code)
      end

      def conflict!(message, code: '409')
        respond_with_error!(409, message || 'Conflict', code)
      end

      def gone!(message, code: '410')
        respond_with_error!(410, message || 'Gone', code)
      end

      def unprocessable!(message, code: '422')
        respond_with_error!(422, message || 'Unprocessable Entity', code)
      end

      def server_error!(message, code: '500')
        respond_with_error!(500, message || 'Internal Server Error', code)
      end
    end
  end
end
