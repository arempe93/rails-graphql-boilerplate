# frozen_string_literal: true

module Scalars
  class BaseScalar < GraphQL::Schema::Scalar
    def self.default_graphql_name
      name.split('::').last.sub('Scalar', '')
    end
  end
end
