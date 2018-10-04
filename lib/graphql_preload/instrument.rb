# frozen_string_literal: true

module GraphqlPreload
  class Instrument
    def instrument(_type, field)
      return field unless field.metadata[:preload].present?

      prev_resolver = field.resolve_proc
      next_resolver = ->(obj, args, ctx) do
        return prev_resolver.call(obj, args, ctx) unless obj

        preload_scope = field.metadata[:preload_scope]
        scope = resolve_scope(preload_scope, obj, args, ctx) if preload_scope

        preload(obj.object, field.metadata[:preload], scope).then do
          prev_resolver.call(obj, args, ctx)
        end
      end

      field.redefine { resolve(next_resolver) }
    end

    private

    def preload(object, associations, scope)
      case associations
      when Symbol then preload_single(object, associations, scope)
      when String then preload_single(object, associations.to_sym, scope)
      when Array, Hash then preload_many(object, Array.wrap(associations), scope)
      end
    end

    def preload_many(object, associations, scope)
      wrap_in_promises do
        associations.each_with_object([]) do |association, promises|
          case association
          when Symbol
            promises << preload_single(object, association, scope)
          when Array
            association.each { |sub| promises << preload(object, sub, scope) }
          when Hash
            association.each do |sub, nested|
              promises << preload_single(object, sub, scope).then do |records|
                preload_nested(records, nested)
              end
            end
          end
        end
      end
    end

    def preload_nested(records, nested)
      # NOTE: handle loaders that may not return ActiveRecord Relations
      case records
      when ActiveRecord::Base then preload(records, nested, nil)
      else
        wrap_in_promises do
          Array.wrap(records).map { |record| preload(record, nested, nil) }
        end
      end
    end

    def preload_single(object, association, scope)
      symbol_check!(association)

      loader_type = object.is_a?(ActiveRecord::Base) ? RecordLoader : EntityLoader

      loader = loader_type.for(object.class, association, scope.try(:to_sql))
      loader.scope = scope
      loader.load(object)
    end

    def resolve_scope(preload_scope, obj, args, ctx)
      if preload_scope.respond_to?(:call)
        preload_scope.call(obj.object, args, ctx)
      else
        kwargs = args.to_h.transform_keys { |k| k.underscore.to_sym }
        return obj.object.public_send(preload_scope.to_sym) if kwargs.empty?

        obj.object.public_send(preload_scope.to_sym, **kwargs)
      end
    end

    def symbol_check!(input)
      raise TypeError, "Expected #{input} to be a Symbol" unless input.is_a?(Symbol)
    end

    def wrap_in_promises
      Promise.all(yield)
    end
  end
end
