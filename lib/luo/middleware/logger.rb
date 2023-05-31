# frozen_string_literal: true
module Luo
  module Middleware
    class Logger < Base

      setting :level, default: ::Logger::INFO
      setting :logger, default: ::Logger.new(STDOUT)

      call do |env|
        logger = config.logger
        logger.level = config.level
        env.create_method(:logger) do
          logger
        end
      end

    end
  end
end
