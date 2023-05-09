# frozen_string_literal: true

module Luo
  class Agent
    attr_reader :context, :action_input, :client
    def initialize(context: nil, action_input: nil, client: nil)
      @context = context
      @action_input = action_input
      @client = client
    end

    def call
      raise NotImplementedError, "call method must be implemented in subclass"
    end

    class << self

      # Agent 运行被调用时会调用 on_call 方法，注意如果 on_call 方法返回 nil，那么最终结果就会是 nil
      def on_call(&block)
        define_method(:call, &block)
      end

      # Agent 运行被调用时会调用 on_call_with_final_result 方法，
      # 注意如果 on_call_with_final_result 方法返回 nil，那么最终结果就会是调用一次大模型来获取结果
      def on_call_with_final_result(&block)
        define_method(:call) do
          result = instance_eval(&block)
          if result.nil?
            messages = context.messages.to_a[0...-1] + [{role: :user, content: context.user_input}]
            context.final_result = client.chat(messages)
          else
            context.final_result = result
          end
        end
      end

      def self.create_parameter_method(method_name, not_provided = Object.new, &block)
        define_method(method_name.to_sym) do |content = not_provided|
          if content === not_provided
            class_variable_get("@@#{method_name}")
          else
            content = block.call(content) if block_given?
            class_variable_set("@@#{method_name}", content)
          end
        end
      end

      create_parameter_method(:agent_desc) { |content| content.gsub(/\n/, "") }
      create_parameter_method(:agent_name) { |context| context.gsub(/[[:punct:]]/, '') }

    end

  end
end
