# frozen_string_literal: true

module API
  module Support
    module Params
      extend Grape::API::Helpers

      params :pagination do |options|
        optional :page, type: Integer, default: 1, values: ->(v) { v.positive? }
        optional :per_page, type: Integer, default: options.fetch(:per_page, 20)
      end

      params :sorting do |options|
        optional :sort_by, type: String, default: options[:sort_by][0], values: options[:sort_by]
        optional :sort_direction, type: String, default: options[:sort_direction], values: %w[asc desc]
      end
    end
  end
end
