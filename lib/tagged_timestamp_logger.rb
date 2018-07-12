# frozen_string_literal: true

require_relative './ansi_color.rb'

module TaggedTimestampLogger
  module Formatter
    extend ANSIColor

    module_function

    def call(_severity, time, _progname, message)
      timestamp = time.utc.strftime('%Y-%m-%d %H-%M-%S.%L')

      "#{black("[#{timestamp}]", bold: true)} #{tags_text}#{message}\n"
    end
  end

  def self.new(path)
    logger = Logger.new(path)
    logger.formatter = Formatter
    ActiveSupport::TaggedLogging.new(logger)
  end
end
