# frozen_string_literal: true

module Mutations
  class BaseMutation < GraphQL::Schema::Mutation
    alias query_context context
    alias ctx context

    class_attribute :data_key
    class_attribute :data_entity

    field :errors, [Types::ErrorType], null: false

    class << self
      def data(key, type, null: true, **kwargs, &block)
        self.data_key = key
        field(key, type, null: null, **kwargs, &block)
      end

      def entity(entity_class)
        self.data_entity = entity_class
      end
    end

    def entity(object)
      if self.class.data_entity
        self.class.data_entity.wrap(object, query_context)
      else
        object
      end
    end

    def error!(klazz, *args)
      error = klazz.new(name, *args)
      raise error
    end

    def name
      self.class.graphql_name.camelize :lower
    end

    def resolve(**kwargs)
      { errors: [] }.tap do |response|
        value = mutate(**kwargs)
        response[self.class.data_key] = entity(value) if self.class.data_key
      end
    rescue Errors::BaseError => e
      { errors: [e] }.tap do |response|
        response[self.class.data_key] = nil
      end
    end
  end
end
