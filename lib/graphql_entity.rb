# frozen_string_literal: true

module GraphqlEntity
  GraphQL::Schema::Field.prepend FieldMetadata

  def self.use(schema_defn)
    schema_defn.instrument(:field, Instrument.new)
  end
end

require_relative 'graphql_entity/field_metadata'
require_relative 'graphql_entity/instrument'
