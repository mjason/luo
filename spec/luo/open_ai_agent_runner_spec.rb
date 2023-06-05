# frozen_string_literal: true

require 'rspec'

RSpec.describe 'Luo::OpenAIAgentRunner' do

  # 天气的Agent
  class WeatherAgent < Luo::Agent::Base
    agent_name 'weather'
    agent_desc '通过文本查询天气(注意需要包含完整意图的句子), 例如: 明天天气怎么样'

    on_call do
      messages = Luo::Messages.create.user(text: context.user_input)
      response = Luo::AIUI.new.chat(messages)
      response.dig("text")
    end
  end

  class OpenAIRunner < Luo::OpenAIAgentRunner
    register WeatherAgent
  end

  before do
    Luo::Agent::Runner.config.language = 'zh'
  end

  let(:runner) { OpenAIRunner.new }

  it 'should return an answer' do
    context = runner.call('明天天气怎么样')
    context2 = runner.call('罗纳尔多是谁')

    expect(context.final_result).not_to be_nil
    expect(context2.final_result).not_to be_nil

    expect(context.histories.size).to eq(1)
    expect(context2.histories.size).to eq(2)
  end
end
