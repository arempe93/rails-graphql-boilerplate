# frozen_string_literal: true

module TaggedTimestampLogger
  module_function

  def call(_severity, timestamp, _progname, message)
    "\e[30;1m[#{timestamp.strftime('%Y-%m-%d %H:%M:%S.%L')}]\e[0m #{tags_text}#{message}\n"
  end
end
