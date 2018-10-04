# frozen_string_literal: true

module Entities
  class BaseEntity
    class << self
      def wrap(object, ctx)
        return nil if object.nil?
        return object if object.is_a?(self)

        if object.respond_to?(:then)
          object.then { |o| wrap(o, ctx) }
        elsif object.respond_to?(:map)
          object.map { |o| wrap(o, ctx) }
        else
          new(object, ctx)
        end
      end
    end

    attr_reader :object, :query_context

    delegate_missing_to :object

    def initialize(object, query_context)
      @object = object
      @query_context = query_context
    end

    def id
      @object.respond_to?(:uuid) ? object.uuid : object&.id
    end

    def model
      @object
    end
  end
end
