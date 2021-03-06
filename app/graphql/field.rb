# frozen_string_literal: true

class Field < GraphQL::Schema::Field
  prepend GraphQLAuthorize
  prepend GraphQLPreload
end
