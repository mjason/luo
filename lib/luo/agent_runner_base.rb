# frozen_string_literal: true

module Luo
  class AgentRunnerBase

    include Configurable

    setting :language, default: "en"
    setting :client, default: nil
    setting :context_adapter, default: -> { Luo::AgentRunnerContext.new }

    def initialize(histories: nil)
      context.histories = histories unless histories.nil?
      on_init
    end

    def on_init
    end

    def client
      raise Luo::ClientNotSetError, "client not set" if self.class.config.client.nil?
      self.class.config.client
    end

    def context
      @context ||= config.context_adapter.call
    end

    def reset_context
      histories = context.histories
      @context = config.context_adapter.call
      @context.histories = histories
      @context
    end

    def call(user_input)
      context.user_input = user_input
      on_request
      on_result
      on_run
      after_run
      rt = Marshal.load(Marshal.dump(context))
      reset_context
      rt
    end

    def on_request
      raise NotImplementedError, "call method must be implemented in subclass"
    end

    def on_result
      raise NotImplementedError, "call method must be implemented in subclass"
    end

    def after_run
    end

    def on_run
      context.have_running_agents.each do |agent|
        context.agent_results << { agent_name: agent.class.agent_name, agent_response: agent.call }
      end
      context.have_running_agents.clear
    end

    def add_agent(agent)
      context.have_running_agents << agent
    end

    def save_history
      context.histories.save(context.user_input, context.final_result) if save_history?
    end

    # @private
    private
    def save_history?
      true
    end

    class << self

      def agents
        @agents ||= {}
      end

      [:on_result, :on_request, :on_init, :after_run].each do |method_name|
        define_method(method_name) do |&block|
          define_method(method_name, &block)
        end
      end

      def register(agent)
        agents[agent.agent_name] = agent
      end

      def language_info
        if self.config.language == "en"
          ""
        elsif self.config.language == "zh"
          "(must be a Chinese string)"
        else
          ""
        end
      end

      def disable_history
        define_method(:save_history?) do
          false
        end
      end

    end
  end
end
