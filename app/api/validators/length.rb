# frozen_string_literal: true

module API
  module Validators
    class Length < Grape::Validations::Base
      def validate_param!(name, params)
        return if params[name].length <= @option

        message = "must be at most #{@option} characters"
        raise Grape::Exceptions::Validation, params: [@scope.full_name(name)], message: message
      end
    end
  end
end
