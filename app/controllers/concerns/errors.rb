# frozen_string_literal: true

require 'active_support/concern'

module Errors
  extend ActiveSupport::Concern

  included do
    def render_error(message:, source:, status: 500)
      payload = {
        error: { message: message, source: source }
      }

      render json: payload, status: status
    end
  end
end
