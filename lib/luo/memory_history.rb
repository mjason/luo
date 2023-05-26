# frozen_string_literal: true

module Luo

  ##
  # 用来保存回话历史的简单内存队列
  class MemoryHistory
    include Configurable

    setting :max_size, default: 6

    attr_reader :context
    ##
    # 初始化一个队列
    # @param [Integer] max_size 队列的最大长度
    def initialize(context = nil, max_size: config.max_size)
      @context = context
      @queue = []
      @max_size = max_size
    end

    ##
    # 入队
    def enqueue(element)
      if @queue.size == @max_size
        @queue.shift
      end
      @queue << element
    end

    def clone
      Marshal.load(Marshal.dump(self))
    end

    def save(input, output)
      @context_model ||= true
      enqueue({input: input, output: output})
    end

    def context_model
      @context_model
    end

    def user(content)
      enqueue({role: "user", content: content})
    end

    def assistant(content)
      enqueue({role: "assistant", content: content})
    end

    alias push enqueue

    def dequeue
      @queue.shift
    end

    def size
      @queue.size
    end

    def to_a
      return @queue unless context_model

      @queue.reduce([]) do |rt, node|
        rt << {role: "user", content: node[:input]}
        rt << {role: "assistant", content: node[:output]}
        rt
      end
    end

    def search(_input)
      to_a
    end

    def to_json
      JSON.pretty_generate @queue
    end
  end
end
