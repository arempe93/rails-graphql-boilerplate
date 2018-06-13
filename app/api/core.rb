# frozen_string_literal: true

module API
  class Core < Grape::API
    include Grape::Extensions::Hash::ParamBuilder
  end
end
