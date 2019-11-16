# frozen_string_literal: true

module GraphQLEntity
  class FieldExtension < GraphQL::Schema::FieldExtension
    def after_resolve(value:, context:, **)
      options[:entity].wrap(value, context)
    end
  end
end
