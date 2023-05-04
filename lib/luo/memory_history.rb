# frozen_string_literal: true

module Luo

  ##
  # 用来保存回话历史的简单内存队列
  class MemoryHistory

    ##
    # 初始化一个队列
    # @param [Integer] max_size 队列的最大长度
    def initialize(max_size = 12)
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
