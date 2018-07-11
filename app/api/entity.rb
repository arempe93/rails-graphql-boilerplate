# frozen_string_literal: true

module API
  class Entity < Grape::Entity
    DOCUMENTATION_OPTIONS = %i[type values example is_array].freeze

    class << self
      alias grape_expose expose

      def expose(name, **options, &block)
        exposure_options = options.slice!(*DOCUMENTATION_OPTIONS)

        options[:type] = options[:type].to_s if options.key?(:type)
        options[:required] = true unless options.delete(:optional)

        exposure_options[:documentation] = options

        grape_expose(name, exposure_options, &block)
      end
    end
  end
end
