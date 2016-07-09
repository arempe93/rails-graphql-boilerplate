module API
  module Support
    module Helpers
      def set(params)
        params.delete :auth_token
        declared(params).to_hash.compact.deep_symbolize_keys
      end

      def validate!(model, code = '422')
        unprocessable! code, "#{model.class.name}: #{model.errors.full_messages.join(', ')}" unless model.valid?
      end
    end
  end
end