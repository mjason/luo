# frozen_string_literal: true

module Luo::Agent

  class SparkRunner < Runner

    setting :retires, default: 3
    setting :prompts do
      setting :input, default: Luo::Prompts.xinghuo_agent_input
      setting :response_error, default: Luo::Prompts.xinghuo_response_error
    end
    setting :client, default: Luo::LLM::Spark.new
    setting :stream_callback, default: nil

    def request(messages)
      if config.stream_callback&.respond_to? :call
        client.chat(messages, &config.stream_callback)
      else
        client.chat(messages)
      end
    end

    on_request do
      context.messages = Luo::Messages.create(history: context.histories.search(context.user_input))
                                 .user(prompt: config.prompts.input, context: {agents: self.class.agents, last_user_input: context.user_input})
      response = request(context.messages)
      if response.split("\n").select { |line| line.size >1  }.size > 1
        message = Luo::Messages.create(history: context.histories.search(context.user_input))
                          .user(prompt: config.prompts.input, context: {agents: self.class.agents, last_user_input: context.user_input})
                          .assistant(text: response)
                          .user(prompt: config.prompts.response_error, context: {agents: self.class.agents, last_user_input: context.user_input})
        context.response = request(message)
      else
        context.response = response
      end
    end

    on_result do
      agent_name = context.response.scan(/调用工具(.*)/).flatten.reject(&:empty?).map(&:to_s)&.last&.gsub(/[[:punct:]]/, '')
      if self.class.agents.include?(agent_name)
        agent = self.class.agents[agent_name]&.new(
          context: context,
          action_input: context.user_input,
          client: client
        )
        add_agent(agent)
      else
        messages = Luo::Messages.create(history: context.histories.search(context.user_input)).user(text: context.user_input)
        context.final_result = request(messages)
      end
    end

    after_run do
      if context.final_result.nil?
        answer = context.response.match(/最终回答：(.*)/)&.captures&.first&.strip
        context.final_result = answer if answer
      end

      save_history
    end
  end

  class SparkFinalAgent < Base
    agent_name '智能问答'
    agent_desc '你可以问我任何问题，我都会尽力回答你'

    on_call_with_final_result do
      messages = Luo::Messages.create(history: context.histories.search(context.user_input)).user(text: context.user_input)
      client.chat(messages)
    end

  end
end
