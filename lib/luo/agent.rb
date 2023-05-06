# frozen_string_literal: true

module Luo
  class Agent
    attr_reader :context, :action_input
    def initialize(context: nil, action_input: nil)
      @context = context
      @action_input = action_input
    end

    def call
      raise NotImplementedError, "call method must be implemented in subclass"
    end

    class << self
      def on_call(&block)
        define_method(:call, &block)
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
