# frozen_string_literal: true

module GraphQLAuthorize
  class Policy
    def and(*policies)
      PolicyChain.new(:and, self, *policies)
    end

    def call(**)
      raise NotImplementedError, 'Policy objects must implement #call'
    end

    def or(*policies)
      PolicyChain.new(:or, self, *policies)
    end
  end
end
