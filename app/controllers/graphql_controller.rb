# frozen_string_literal: true

class GraphqlController < ApplicationController
  def execute
    result = if params[:_json]
               GraphqlService.multiplex(params[:_json], context: context)
             else
               GraphqlService.execute(params, context: context)
             end

    render json: result
  rescue StandardError => error
    Rails.logger.error error.message
    Rails.logger.error error.backtrace.join("\n")

    render_error(error)
  end

  private

  def context
    raw_token = auth_header
    token = AuthenticationService.verify(raw_token)

    {
      raw_token: raw_token,
      token: token,
      user_id: token&.fetch(:sub, nil)
    }
  end

  def render_error(error)
    payload = {
      error: { message: error.message, source: error.backtrace.first }
    }

    render json: payload, status: 500
  end
end
