# frozen_string_literal: true

module Middleware
  module Database
    DB_RUNTIME_KEY = :grape_db_runtime

    def db_runtime=(value)
      RequestStore.store[DB_RUNTIME_KEY] = value
    end

    def db_runtime
      RequestStore.store[DB_RUNTIME_KEY] ||= 0
    end

    def reset_db_runtime
      self.db_runtime = 0
    end

    def append_db_runtime(event)
      self.db_runtime += event.duration
    end

    def total_db_runtime
      db_runtime.round(2)
    end
  end
end
