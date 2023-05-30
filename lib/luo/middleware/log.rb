# frozen_string_literal: true

module Luo
  module Middleware
    class Log < Base

      after do |env|
        puts env
      end
    end
  end
end
