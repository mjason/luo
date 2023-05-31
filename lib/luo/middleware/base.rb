# frozen_string_literal: true

module Luo
  module Middleware
    class Base
      extend Dry::Configurable
      def initialize(app)
        raise ArgumentError, "app must respond to `call`" unless app.respond_to? :call
        @app = app
      end

      def call(env)
        env = Env.validate_env!(env)
        env = Env.validate_env! _before_call_(env)
        env = Env.validate_env! _call_(env)
        env = Env.validate_env! @app.call(env)
        Env.validate_env! _after_call_(env)
      end

      def _before_call_(env)
        env
      end

      def _after_call_(env)
        env
      end

      def _call_(env)
        env
      end

      class << self

        def create_method(name, &block)
          define_method name do |env|
            _env_ = block.call(env)
            if _env_.is_a? Env
              _env_
            else
              env
            end
          end
        end

        def before(&block)
          create_method :_before_call_, &block
        end

        def after(&block)
          create_method :_after_call_, &block
        end

        def call(&block)
          create_method :_call_, &block
        end

      end

    end
  end
end
