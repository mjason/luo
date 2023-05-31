# frozen_string_literal: true

module Luo
  module Middleware
    module MemoryHistory
      extend self

      def create(history)
        Class.new(Base) do
          @history = history
          def initialize(app)
            @app = app
          end

          before do |env|
            env.set(:history, @history)
          end

          after do |env|
            @history.user env.fetch(:input)
            @history.assistant env.fetch(:output)
          end

        end
      end
    end
  end
end
