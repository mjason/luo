# frozen_string_literal: true

require 'rspec'

RSpec.describe 'Luo::Agent' do


  before do
    class HelloAgent < Luo::Agent
      agent_desc "This agent greets you."
      agent_name "hello."

      on_call do
        "Hello, world!"
      end
    end
  end

  let(:agent) { HelloAgent.new("hello") }

  it "should greet you" do
    expect(agent.call).to eq("Hello, world!")
  end

  it "should have a description" do
    expect(HelloAgent.agent_desc).to eq("This agent greets you.")
  end

  it "should have a name" do
    expect(HelloAgent.agent_name).to eq("hello")
  end
end
