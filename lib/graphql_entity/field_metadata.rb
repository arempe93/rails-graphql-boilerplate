# frozen_string_literal: true

module GraphqlEntity
  module FieldMetadata
    def initialize(entity: nil, **kwargs, &block)
      @entity = entity
      super(**kwargs, &block)
    end

    def entity(type)
      @entity = type
    end

    def to_graphql
      super.tap do |defn|
        defn.metadata[:entity] = @entity
      end
    end
  end
end
