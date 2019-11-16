# frozen_string_literal: true

module Spatial
  class Geometry
    def to_hex
      to_wkb.unpack('H*').first
    end
  end
end
