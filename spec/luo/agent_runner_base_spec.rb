# frozen_string_literal: true

require 'rspec'

RSpec.describe 'Luo::AgentRunnerBase' do
  before do

    class AgentBaseHelloAgent < Luo::Agent
      agent_desc "This agent greets you."
      agent_name "hello"

      on_call do
        "Hello, world!"
      end
    end

    class AgentBaseRunner < Luo::AgentRunnerBase
      register AgentBaseHelloAgent

      on_request do
        messages = Luo::Messages.create.user(text: context.user_input)
        context.response = Luo::OpenAI.new.chat(messages)
      end

      on_result do
        add_agent AgentBaseHelloAgent.new(context: Luo::AgentRunnerContext.new)
      end
    end

  end

  it "should have a registered agent" do
    expect(AgentBaseRunner.instance_variable_get("@agents").keys).to include("hello")
  end

  it "should have a context" do
    runner = AgentBaseRunner.new
    runner.context.user_input = "hello"
    expect(runner.context.user_input).to eq("hello")
  end

  it "should have call agent" do
    runner = AgentBaseRunner.new
    context = runner.call("hello")

    expect(context.agent_results.last[:agent_response]).to eq("Hello, world!")
  end
end
