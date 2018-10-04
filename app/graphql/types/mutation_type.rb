# frozen_string_literal: true

module Types
  class MutationType < Types::BaseObject
    description 'The mutation root of this schema'
    graphql_name 'Mutation'
  end
end
