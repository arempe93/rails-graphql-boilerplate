# frozen_string_literal: true

class ApplicationController < ActionController::Base
  include Authorization
  include Errors

  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  # protect_from_forgery with: :exception
  protect_from_forgery with: :null_session

  around_action :log_with_request_id

  private

  def log_with_request_id
    Rails.logger.tagged(RequestStore[:request_id]) do
      yield
    end
  end
end
