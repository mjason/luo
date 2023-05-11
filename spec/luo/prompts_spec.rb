# frozen_string_literal: true

require 'rspec'

RSpec.describe Luo::Prompts do
  describe '#define_templates' do
    it 'should define templates' do
      expect(Luo::Prompts).to respond_to(:agent_input)
      expect(Luo::Prompts).to respond_to(:agent_system)
      expect(Luo::Prompts).to respond_to(:agent_tool_input)
      expect(Luo::Prompts).to respond_to(:xinghuo_agent_input)
    end
  end

  describe '#define_templates_in_runtimes' do

    it 'should define templates in dir' do
      expect(Luo::Prompts).to respond_to(:demo)
    end

  end
end

