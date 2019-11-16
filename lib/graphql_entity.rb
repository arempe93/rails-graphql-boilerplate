# frozen_string_literal: true

module GraphQLEntity
  def initialize(entity: nil, **kwargs, &block)
    super(**kwargs, &block)

    @entity ||= entity
    return unless @entity.present?

    extension(FieldExtension, entity: @entity)
  end

  def entity(value)
    @entity = value
  end

  def to_graphql
    super.tap do |defn|
      defn.metadata[:entity] = @entity
    end
  end
end
