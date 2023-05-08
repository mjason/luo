# frozen_string_literal: true

require 'rspec'

RSpec.describe 'Luo::AgentRunnerContext' do

  it 'should be a default adapter' do
    expect(Luo::AgentRunnerContext.config.history_adapter).to eq Luo::MemoryHistory
  end

  it 'change the adapter' do
    class MyAdapter; end
    Luo::AgentRunnerContext.config.history_adapter = MyAdapter
    expect(Luo::AgentRunnerContext.config.history_adapter).to eq MyAdapter
  end
end
