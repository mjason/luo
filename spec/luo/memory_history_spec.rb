# frozen_string_literal: true

require 'rspec'

RSpec.describe Luo::MemoryHistory do
  describe '#initialize' do
    it 'should create an empty queue with default size' do
      history = Luo::MemoryHistory.new
      expect(history.size).to eq 0
    end

    it 'should create an empty queue with custom size' do
      history = Luo::MemoryHistory.new(5)
      expect(history.size).to eq 0
    end
  end

  describe '#enqueue' do
    it 'should add an element to the queue' do
      history = Luo::MemoryHistory.new
      history.enqueue("message")
      expect(history.size).to eq 1
    end

    it 'should remove oldest element if queue is at maximum size' do
      history = Luo::MemoryHistory.new(2)
      history.enqueue("message 1")
      history.enqueue("message 2")
      history.enqueue("message 3")
      expect(history.to_a).to eq ["message 2", "message 3"]
    end
  end

  describe '#push' do
    it 'should add an element to the queue' do
      history = Luo::MemoryHistory.new
      history.push("message")
      expect(history.size).to eq 1
    end

    it 'should remove oldest element if queue is at maximum size' do
      history = Luo::MemoryHistory.new(2)
      history.push("message 1")
      history.push("message 2")
      history.push("message 3")
      expect(history.to_a).to eq ["message 2", "message 3"]
    end
  end

  describe '#dequeue' do
    it 'should remove and return the first element in the queue' do
      history = Luo::MemoryHistory.new
      history.enqueue("message")
      expect(history.dequeue).to eq "message"
      expect(history.size).to eq 0
    end

    it 'should return nil if the queue is empty' do
      history = Luo::MemoryHistory.new
      expect(history.dequeue).to be_nil
    end
  end

  describe '#size' do
    it 'should return the current size of the queue' do
      history = Luo::MemoryHistory.new
      history.enqueue("message")
      expect(history.size).to eq 1
      history.enqueue("message")
      expect(history.size).to eq 2
    end
  end

  describe '#to_a' do
    it 'should return an array representation of the queue' do
      history = Luo::MemoryHistory.new
      history.enqueue("message 1")
      history.enqueue("message 2")
      expect(history.to_a).to eq ["message 1", "message 2"]
    end
  end

  describe '#to_json' do
    it 'should return a pretty JSON representation of the queue' do
      history = Luo::MemoryHistory.new
      history.enqueue("message 1")
      history.enqueue("message 2")
      expect(history.to_json).to eq "[\n  \"message 1\",\n  \"message 2\"\n]"
    end
  end
end

