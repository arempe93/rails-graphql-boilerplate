# frozen_string_literal: true

module Policies
  class GraphqlPolicy
    def self.guard(type, _field)
      # NOTE: allow introspection queries without an auth token (e.g., to get the schema)
      ->(_obj, _args, ctx) { type.introspection? ? true : ctx[:user_id].present? }
    end
  end
end
