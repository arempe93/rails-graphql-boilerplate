# frozen_string_literal: true

module Types
  class BaseObject < GraphQL::Schema::Object
    alias ctx context
  end
end
