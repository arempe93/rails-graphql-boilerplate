# frozen_string_literal: true

module Policies
  class Authenticated < BasePolicy
    def call(context:, **)
      context[:user_id].present?
    end
  end
end
