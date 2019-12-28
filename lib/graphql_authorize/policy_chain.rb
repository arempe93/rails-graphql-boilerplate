# frozen_string_literal: true

module GraphQLAuthorize
  class PolicyChain
    class << self
      def wrap(value)
        case value
        when PolicyChain then value
        when Policy then new(:and, value)
        else
          raise ArgumentError, "cannot wrap #{value.inspect}"
        end
      end
    end

    attr_reader :operator
    attr_reader :policies

    def initialize(operator, *policies)
      @operator = operator
      @policies = policies
    end

    def and(**kwargs)
      policies.reduce(true) do |memo, policy|
        memo && policy.call(**kwargs)
      end
    end

    def call(**kwargs)
      public_send(operator, **kwargs)
    end

    def or(**kwargs)
      policies.reduce(false) do |memo, policy|
        memo || policy.call(**kwargs)
      end
    end
  end
end
