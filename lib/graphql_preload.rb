# frozen_string_literal: true

module GraphqlPreload
  GraphQL::Schema::Field.prepend FieldMetadata

  def self.use(schema_defn)
    schema_defn.instrument(:field, Instrument.new)
  end
end

require_relative 'graphql_preload/entity_loader'
require_relative 'graphql_preload/field_metadata'
require_relative 'graphql_preload/instrument'
require_relative 'graphql_preload/record_loader'
