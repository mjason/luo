# frozen_string_literal: true

module Luo
  module Middleware
    class Base
      def initialize(app)
        raise ArgumentError, "app must respond to `call`" unless app.respond_to? :call
        @app = app
      end

      def call(env)
        env = Env.validate_env!(env)
        env = Env.validate_env! before_call(env)
        env = Env.validate_env! @app.call(env)
        Env.validate_env! after_call(env)
      end

      def before_call(env)
        env
      end

      def after_call(env)
        env
      end

      class << self
        def before(&block)
          define_method :before_call do |env|
            _env_ = block.call(env)
            if _env_.is_a? Env
              _env_
            else
              env
            end
          end
        end

        def after(&block)
          define_method :after_call do |env|
            _env_ = block.call(env)
            if _env_.is_a? Env
              _env_
            else
              env
            end
          end
        end
      end

    end
  end
end
