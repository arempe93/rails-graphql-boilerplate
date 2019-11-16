# frozen_string_literal: true

class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true

  class << self
    def base_class_name
      base_class.name
    end
  end

  def base_class_name
    self.class.base_class.name
  end

  def saved_attributes(except: %w[updated_at])
    saved_changes.except(*except)
  end
end
