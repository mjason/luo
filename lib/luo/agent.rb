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
      def on_call(&block)
        define_method(:call, &block)
      end

      def on_call_with_final_result(&block)
        define_method(:call) do
          context.final_result = instance_eval(&block)
          context.final_result
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
