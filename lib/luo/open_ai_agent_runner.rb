# frozen_string_literal: true

module Luo
  class OpenAIAgentRunner < AgentRunnerBase

    include Configurable

    setting :retires, default: 3

    on_init do
      @openai = OpenAI.new
    end

    on_request do
      context.messages = Messages.create(history: context.histories)
                         .system(prompt: Luo::Prompts.luo_agent_system)
                         .user(prompt: Luo::Prompts.luo_agent_input, context: {agents: self.class.agents, last_user_input: context.user_input})
      context.response = @openai.chat(context.messages)
    end

    on_result do
      actions = JSON.parse(context.response)
      actions = [actions] if actions.is_a?(Hash)
      actions.each do |action|
        agent = self.class.agents[action['action']]&.new(
          context: context,
          action_input: action['action_input'],
          client: @openai
        )
        add_agent(agent) if agent
        if action['action'] == "Final Answer"
          context.final_result = action['action_input']
          context.histories.user(context.user_input)
          context.histories.assistant(context.final_result)
        end
      end
    end

    after_run do
      if context.retries < config.retires && context.final_result.nil?
        context.messages = context.messages.assistant(
          prompt: Luo::Prompts.luo_agent_tool_input,
          context: {
            tools_response: context.agent_results
          }
        )
        context.response = @openai.chat(context.messages)
        context.retries += 1
        on_result
        on_run
        after_run
      end
    end
  end
end
