# frozen_string_literal: true

require 'graphql_authorize'
require 'graphql_preload'
require 'graphql_entity'

class Schema < GraphQL::Schema
  query Types::QueryType
  mutation Types::MutationType

  # use new ruby-graphql 1.9+ runtime
  use GraphQL::Execution::Interpreter
  use GraphQL::Analysis::AST

  # add guard ability to fields
  # use GraphQL::Guard.new #(policy_object: Policies::GraphQLPolicy)
  use GraphQLAuthorize

  # preload and wrap records
  use GraphQL::Batch
  use GraphQLPreload
  use GraphQLEntity

  # max_depth 10

  middleware(GraphQL::Schema::TimeoutMiddleware.new(max_seconds: 5) do |_err, query|
    Rails.logger.info "GraphQL Timeout: #{query.query_string}"
  end)
end
