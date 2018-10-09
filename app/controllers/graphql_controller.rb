# frozen_string_literal: true

class GraphqlController < ApplicationController
  def execute
    result = if params[:_json]
               GraphqlService.multiplex(params[:_json], context: context)
             else
               GraphqlService.execute(params, context: context)
             end

    render json: result
  rescue GraphQL::Guard::NotAuthorizedError => error
    render_error(message: 'Not Authorized', source: error.message, status: 401)
  rescue StandardError => error
    Rails.logger.error error.message
    Rails.logger.error error.backtrace.join("\n")

    render_error(message: error.message, source: error.backtrace.first)
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

  def render_error(message:, source:, status: 500)
    payload = {
      error: { message: message, source: source }
    }

    render json: payload, status: status
  end
end
