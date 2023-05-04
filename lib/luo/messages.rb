# frozen_string_literal: true

module Luo
  class Messages
    def initialize
      @messages = []
      @system = {}
    end

    def system(text: nil, file: '')
      data = text || File.read(file)
      @system = {role: "system", content: data}
      self
    end

    def user(text: nil, file: '')
      data = text || File.read(file)
      @messages << {role: "user", content: data}
      self
    end

    def assistant(text: nil, file: '')
      data = text || File.read(file)
      @messages << {role: "assistant", content: data}
      self
    end

    def to_a
      if @system.empty?
        @messages
      else
        @messages.unshift @system
      end
    end

    class << self
      def create
        self.new
      end
    end

  end
end
