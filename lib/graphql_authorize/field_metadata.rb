# frozen_string_literal: true

module GraphQLAuthorize
  module FieldMetadata
    def initialize(authorize: nil, **kwargs, &block)
      @authorize = authorize
      super(**kwargs, &block)
    end

    def authorize(value)
      @authorize = value
    end

    def to_graphql
      super.tap do |defn|
        defn.metadata[:authorize] = @authorize
      end
    end
  end
end
