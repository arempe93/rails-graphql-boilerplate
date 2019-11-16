# frozen_string_literal: true

module GraphQLAuthorize
  def initialize(authorize: nil, **kwargs, &block)
    super(**kwargs, &block)

    @authorize ||= authorize
    return unless @authorize.present?

    extension(FieldExtension, authorize: @authorize)
  end

  def authorize(value)
    @authorize = value
  end

  def to_graphql
    super.tap do |defn|
      defn.metadata[:authorize] = @authorize
    end
  end
end
