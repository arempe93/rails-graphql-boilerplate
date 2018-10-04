# frozen_string_literal: true

class Schema < GraphQL::Schema
  query Types::QueryType
  mutation Types::MutationType

  use GraphQL::Batch
  use GraphqlPreload
  use GraphqlEntity
  use GraphQL::Guard.new(policy_object: Policies::GraphqlPolicy)

  # max_complexity 100
  max_depth 10

  middleware(GraphQL::Schema::TimeoutMiddleware.new(max_seconds: 5) do |_err, query|
    Rails.logger.info("GraphQL Timeout: #{query.query_string}")
  end)
end
