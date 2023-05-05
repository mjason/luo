# frozen_string_literal: true

module Luo
  class Messages
    def initialize(history: [])
      @history = history
      @messages = []
      @system = {}
    end

    def self.create_role_message_method(role)
      define_method(role) do |text: nil, file: '', prompt: nil, context: {}|
        if prompt.nil?
          data = text || File.read(file)
        else
          data = prompt.render(context)
        end
        if role.to_s == "system"
          @system = {role: role, content: data}
        else
          @messages << {role: role, content: data}
        end
        self
      end
    end

    def self.create_role_message_methods
      %w(system user assistant).each do |role|
        create_role_message_method(role)
      end
    end

    create_role_message_methods

    def to_a
      if @system.empty?
        @history.to_a + @messages
      else
        (@history.to_a + @messages).unshift(@system)
      end
    end

    class << self
      def create(history: [])
        self.new(history: history)
      end
    end

  end
end
