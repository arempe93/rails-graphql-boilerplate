# frozen_string_literal: true

module Spatial
  module Types
    class Geometry < ActiveModel::Type::Value
      DOUBLE_PACKFLAG = 'E'
      UINT32_PACKFLAG = 'V'

      def changed_in_place?(old_raw_value, new_value)
        cast_value(old_raw_value) != new_value
      end

      protected

      def to_double(binary)
        binary.unpack(DOUBLE_PACKFLAG).first
      end

      def to_uint32(binary)
        binary.unpack(UINT32_PACKFLAG).first
      end

      private

      def cast_value(value)
        return value if value.is_a?(Spatial::Geometry)

        parse_wkb(value)
      end
    end
  end
end
