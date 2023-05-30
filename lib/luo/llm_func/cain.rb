# frozen_string_literal: true

module Luo
  module LLMFunc
    class Cain
      include Dry::Configurable

      setting :system, default: nil
      setting :prompt
      setting :adapter, default: Luo::OpenAI.llm_func_adapter
      setting :temperature, default: 0


      def call(env)
        temperature = env.fetch(:temperature, nil)
        history = env.fetch(:history, nil)
        messages = Messages.create(history: history).user(prompt: config.prompt, context: env.to_h)

        if config.system
          messages = messages.system(text: config.system)
        end

        response = config.adapter.call(messages, temperature || config.temperature)
        env.set(:response, response)
      end

    end
  end
end
