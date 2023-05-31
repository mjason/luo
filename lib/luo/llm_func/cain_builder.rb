# frozen_string_literal: true

module Luo
  module LLMFunc
    class CainBuilder
      def initialize
        @system = nil
        @prompt = nil
        @adapter = Luo::OpenAI.llm_func_adapter
        @temperature = 0

        @middlewares = []
      end

      def system(text=nil)
        @system = text
        self
      end

      def prompt(prompt=nil)
        @prompt = prompt
        self
      end

      def adapter(adapter=nil)
        @adapter = adapter
        self
      end

      def temperature(temperature=nil)
        @temperature = temperature
        self
      end

      def use(middleware)
        @middlewares << middleware
        self
      end

      def build
        cain = Cain.new.configure do |c|
          c.system = @system
          c.prompt = @prompt
          c.adapter = @adapter
          c.temperature = @temperature
        end

        _next_ = cain
        @middlewares.reverse_each do |middleware|
          _next_ = middleware.new(_next_)
        end

        Proc.new do |**input|
          env = Luo::Middleware::Env.new(**input)
          _next_.call(env)
        end
      end

      def call(**input)
        build.call(**input)
      end

    end
  end
end
