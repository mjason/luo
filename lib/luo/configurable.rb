# frozen_string_literal: true

module Luo
  module Configurable
    def self.included(base)
      base.extend(Dry::Configurable)
    end

    def config
      self.class.config
    end

  end
end
