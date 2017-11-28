# frozen_string_literal: true

module API
  module Support
    module Errors
      def respond_with_error!(status, message, code, backtrace: true)
        payload = { code: code.to_s }
        payload.merge!(message.is_a?(String) ? { message: message } : message)
        payload[:backtrace] = caller.drop(1).take(10) if backtrace

        error!(payload, status)
      end

      def bad_request!(message = 'Bad Request', code: '400')
        respond_with_error!(400, message, code)
      end

      def unauthorized!(message = 'Unauthorized', code: '401')
        respond_with_error!(401, message, code, backtrace: false)
      end

      def payment_required!(message = 'Payment Required', code: '402')
        respond_with_error!(402, message, code)
      end

      def forbidden!(message = 'Forbidden', code: '403')
        respond_with_error!(403, message, code, backtrace: false)
      end

      def not_found!(message = 'Not Found', code: '404')
        respond_with_error!(404, message, code, backtrace: false)
      end

      def conflict!(message = 'Conflict', code: '409')
        respond_with_error!(409, message, code)
      end

      def gone!(message = 'Gone', code: '410')
        respond_with_error!(410, message, code, backtrace: false)
      end

      def unprocessable!(message = 'Unprocessable Entity', code: '422')
        respond_with_error!(422, message, code)
      end

      def server_error!(message = 'Internal Server Error', code: '500')
        respond_with_error!(500, message, code)
      end
    end
  end
end
