# frozen_string_literal: true

module GraphQLAuthorize
  class FieldExtension < GraphQL::Schema::FieldExtension
    def resolve(object:, arguments:, context:)
      passed = options[:authorize].call(object: object,
                                        field: field,
                                        arguments: arguments,
                                        context: context)

      return yield(object, arguments) if passed

      message = "Authorization failed for #{field.owner.graphql_name}.#{field.name}"
      raise AuthorizationError.new(message, extensions: { code: :AUTHORIZATION_FAILED })
    end
  end
end
