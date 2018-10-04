# frozen_string_literal: true

module GraphqlEntity
  class Instrument
    def instrument(_type, field)
      return field unless field.metadata[:entity].present?

      prev_resolver = field.resolve_proc
      next_resolver = ->(obj, args, ctx) do
        value = prev_resolver.call(obj, args, ctx)
        field.metadata[:entity].wrap(value, ctx)
      end

      field.redefine { resolve(next_resolver) }
    end
  end
end
