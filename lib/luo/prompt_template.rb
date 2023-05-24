# frozen_string_literal: true

module Luo
  class PromptTemplate
    def initialize(file_path = nil, text: nil)
      @file_path = file_path
      if text.nil? && !@file_path.nil?
        @template = ERB.new(File.read(@file_path), trim_mode: '-')
      else
        @template = ERB.new(text, trim_mode: '-')
      end
    end

    def render(data = {})
      context = data.is_a?(Hash) ? data : data.each_slice(2).to_h
      @template.result(context_binding(context))
    end

    def result()
      @template.result(binding)
    end

    private
    def context_binding(context)
      context.each do |key, value|
        instance_variable_set("@#{key}", value)
        self.class.send(:attr_reader, key.to_sym)
      end
      binding
    end

    class << self
      def create(file_path)
        self.new(file_path)
      end

      def load_template(file_name)
        self.new File.join(__dir__, '../../templates', 'prompts', file_name)
      end
    end

  end
end
