# frozen_string_literal: true

module Luo
  class XinghuoAgentRunner < AgentRunnerBase
    include Configurable

    setting :retires, default: 3

    on_init do
      @xinghuo = Xinghuo.new
    end

    on_request do
      context.messages = Messages.create(history: context.histories)
                                 .user(prompt: Luo::Prompts.luo_xinghuo_agent_input, context: {agents: self.class.agents, last_user_input: context.user_input})
      context.response = @xinghuo.chat(context.messages)
    end

    on_result do
      agent_name = context.response.match(/调用工具：(.*)/)&.captures&.last&.strip&.gsub(/[[:punct:]]/, '')
      agent = self.class.agents[agent_name]&.new(
        context: context,
        action_input: context.user_input,
        client: @xinghuo
      )
      answer = context.response.match(/最终回答：(.*)/)&.captures&.first&.strip

      if agent_name.nil? && !answer.nil? && agent.nil?
        context.final_result = answer
      else
        add_agent(agent)
      end
    end

    after_run do
      if context.final_result.nil?
        answer = context.response.match(/最终回答：(.*)/)&.captures&.first&.strip
        context.final_result = answer if answer
      end

      context.histories.user(context.user_input)
      context.histories.assistant(context.final_result)
    end
  end

  class XinghuoFinalAgent < Agent
    agent_name '智能问答'
    agent_desc '你可以问我任何问题，我都会尽力回答你'

    on_call_with_final_result do
      messages = Messages.create(history: context.histories).user(text: context.user_input)
      client.chat(messages)
    end

  end
end
