# frozen_string_literal: true

module Types
  class BaseObject < GraphQL::Schema::Object
    include Finders
  end
end
