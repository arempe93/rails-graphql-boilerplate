# frozen_string_literal: true

module GraphQLEntity
  GraphQL::Schema::Field.prepend FieldMetadata

  class << self
    def use(schema_defn)
      schema = schema_defn.target
      return unless schema.query

      schema.query.fields.each { |_, f| add_extension(f) }
    end

    private

    def add_extension(field_defn, visited: {})
      entity = field_defn.metadata[:entity]
      field = field_defn.metadata[:type_class]

      type = field.type
      type = type.of_type while type.is_a?(GraphQL::Schema::Wrapper)

      return if visited[type]
      return unless type < GraphQL::Schema::Object

      visited[type] = true

      field.extension(FieldExtension, entity: entity) if entity.present?

      type.fields.each { |_, f| add_extension(f.to_graphql, visited: visited) }
    end
  end
end
