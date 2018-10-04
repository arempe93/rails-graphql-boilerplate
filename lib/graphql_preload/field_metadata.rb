# frozen_string_literal: true

module GraphqlPreload
  module FieldMetadata
    def initialize(preload: nil, preload_scope: nil, **kwargs, &block)
      @raw_name = kwargs[:name].to_sym
      @preload = preload.is_a?(TrueClass) ? @raw_name : preload if preload
      @preload_scope = preload_scope if preload_scope

      super(**kwargs, &block)
    end

    def preload(value)
      @preload = value.is_a?(TrueClass) ? @raw_name : value
    end

    def preload_scope(value)
      @preload_scope = value
    end

    def to_graphql
      super.tap do |defn|
        defn.metadata[:preload] = @preload
        defn.metadata[:preload_scope] = @preload_scope
      end
    end
  end
end
