# frozen_string_literal: true

require 'rspec'

RSpec.describe 'Luo::XinghuoAgentRunner' do

  class XinghuoWeatherAgent < Luo::Agent
    agent_name '天气查询'
    agent_desc '查询城市的天气情况，穿衣指数，空气质量等'

    on_call_with_final_result do
      messages = Luo::Messages.create.user(text: context.user_input)
      response = Luo::AIUI.new.chat(messages)
      response&.dig("text")
    end
  end

  class XinghuoRunner < Luo::XinghuoAgentRunner
    register XinghuoWeatherAgent
    register Luo::XinghuoFinalAgent
  end

  let(:runner) { XinghuoRunner.new }

  it 'should return an answer' do
    context = runner.call('明天天气怎么样')
    context2 = runner.call('写一首适合情人节的诗')

    expect(context.final_result).not_to be_nil
    expect(context2.final_result).not_to be_nil

    expect(context.histories.size).to eq(1)
    expect(context2.histories.size).to eq(2)
  end
end
