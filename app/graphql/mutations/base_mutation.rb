# frozen_string_literal: true

module Mutations
  class BaseMutation < GraphQL::Schema::Mutation
    include Finders

    protected

    def push_event(action:, subjects:, data: nil)
      EventService.push(action: action,
                        device_id: context[:device_id],
                        user_id: context[:user_id],
                        request_id: context[:request][:id],
                        jti: context[:token]&.jti,
                        subjects: subjects,
                        data: data)
    end

    def with_void_return
      nil.tap { yield }
    end

    def error!(**kwargs)
      raise Errors::BaseError.new(**kwargs)
    end

    def forbidden!(msg = 'Not allowed to access this resource')
      error! message: msg, code: :FORBIDDEN
    end

    def unauthorized!(msg = 'Authentication required')
      error! message: msg, code: :UNAUTHORIZED
    end
  end
end
