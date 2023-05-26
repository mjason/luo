# frozen_string_literal: true

require 'rspec'

RSpec.describe 'Luo::AgentRunnerContext' do

  after do
    Luo::AgentRunnerContext.config.history_adapter = ->(context) { Luo::MemoryHistory.new(context) }
  end

  it 'should be a default adapter' do
    expect(Luo::AgentRunnerContext.config.history_adapter.call(nil)).to be_a Luo::MemoryHistory

  end

  it 'change the adapter' do
    class MyAdapter; end
    Luo::AgentRunnerContext.config.history_adapter = ->(context) { MyAdapter.new }
    expect(Luo::AgentRunnerContext.config.history_adapter.call(nil)).to be_a MyAdapter
  end
end
