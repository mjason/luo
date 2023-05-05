# frozen_string_literal: true

require 'rspec'

RSpec.describe Luo::Xinghuo do
  let(:xinghuo) { Luo::Xinghuo.new }

  describe '#chat' do
    let(:messages) { Luo::Messages.create.user(text: "hello").to_a }

    context 'when passing valid parameters' do

      it 'should return a response' do
        expect(xinghuo.chat(messages)).not_to be_nil
      end
    end

    context 'when passing invalid parameters' do
      let(:messages) { [] }

      it 'should return an error' do
        expect(xinghuo.chat(messages).to_h).to include(:messages)
      end
    end

  end
end
