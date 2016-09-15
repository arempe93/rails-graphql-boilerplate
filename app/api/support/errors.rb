module API
  module Support
    module Errors
      STATUS_TEXT = {
        400 => 'Bad Request',
        401 => 'Unauthorized',
        403 => 'Forbidden',
        404 => 'Not Found',
        422 => 'Unprocessable Entity',
        500 => 'Internal Server Error'
      }

      def respond_with_error!(status, *args)
        message = args.shift || STATUS_TEXT[status]
        code = args.shift || status.to_s
        error!({ code: code, message: message, backtrace: caller.drop(1).take(10) }, status)
      end

      def bad_request!(*args)
        respond_with_error!(400, *args)
      end

      def unauthorized!(*args)
        respond_with_error!(401, *args)
      end

      def forbidden!(*args)
        respond_with_error!(403, *args)
      end

      def not_found!(*args)
        respond_with_error!(404, *args)
      end

      def unprocessable!(*args)
        respond_with_error!(422, *args)
      end

      def server_error!(*args)
        respond_with_error!(500, *args)
      end
    end
  end
end
