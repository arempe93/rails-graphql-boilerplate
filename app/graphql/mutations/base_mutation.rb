# frozen_string_literal: true

module Mutations
  class BaseMutation < GraphQL::Schema::Mutation
    include Finders

    protected

    def with_void_return
      nil.tap { yield }
    end

    def error!(**kwargs)
      raise Errors::BaseError.new(**kwargs)
    end
  end
end
