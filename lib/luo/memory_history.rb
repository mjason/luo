# frozen_string_literal: true

module Luo

  ##
  # 用来保存回话历史的简单内存队列
  class MemoryHistory
    include Configurable

    setting :max_size, default: 12

    ##
    # 初始化一个队列
    # @param [Integer] max_size 队列的最大长度
    def initialize(max_size = config.max_size)
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
      @queue
    end

    def to_json
      JSON.pretty_generate @queue
    end
  end
end
