# frozen_string_literal: true

module Entities
  class BaseEntity
    class << self
      def wrap(object, context)
        return nil if object.nil?
        return object if object.is_a?(self)

        if object.is_a?(Promise)
          object.then { |o| wrap(o, context) }
        elsif object.respond_to?(:map)
          object.map { |o| wrap(o, context) }
        else
          new(object, context)
        end
      end
    end

    attr_reader :object, :context

    delegate_missing_to :object

    def initialize(object, context)
      @object = object
      @context = context
    end

    def id
      @object.respond_to?(:uuid) ? object.uuid : object&.id
    end

    def model
      @object
    end
  end
end
