# frozen_string_literal: true

module Luo
  module Middleware
    class Env
      attr_accessor :meta
      def initialize(**meta)
        @meta = meta
      end

      def set(key, value)
        @meta[key] = value
        self
      end

      def get(key)
        @meta[key]
      end

      def input
        @meta[:input]
      end

      def output
        @meta[:output]
      end

      def fetch(key, default=nil)
        @meta.fetch(key, default)
      end

      def fetch_and_delete!(key, default=nil)
        @meta.fetch(key, default).tap do
          @meta.delete(key)
        end
      end

      def to_s
        @meta.to_s
      end

      def to_h
        @meta
      end

      def self.validate_env!(env)
        raise ArgumentError, "env must be a Luo::Middleware::Env" unless env.is_a? Luo::Middleware::Env
        env
      end
    end
  end
end
