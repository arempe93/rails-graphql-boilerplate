# frozen_string_literal: true

module Errors
  class BaseError < StandardError
    attr_reader :source

    def initialize(source, *path)
      @source = source
      @path = path.flat_map(&:to_s)
    end

    def name
      self.class.name.demodulize
    end

    def path
      [@source, *@path]
    end
  end
end
