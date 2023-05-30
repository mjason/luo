# frozen_string_literal: true

module Luo
  module LLMFunc
    extend self

    def cain(middlewares: [], &block)
      cain = Cain.new.configure(&block)
      _next_ = cain
      middlewares.each do |middleware|
        _next_ = middleware.new(_next_)
      end

      Proc.new do |**input|
        env = Luo::Middleware::Env.new(**input)
        _next_.call(env)
      end
    end

  end
end
