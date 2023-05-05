# frozen_string_literal: true

require 'rspec'

RSpec.describe Luo::AIUI do
  let(:aiui) { Luo::AIUI.new }

  describe '#chat' do
    let(:messages) { [{ role: 'user', content: '明天天气怎么样' }] }
    let(:last_message) { messages.last['content'] }

    context 'when passing valid parameters' do

      it 'should return an answer' do
        # binding.irb
        expect(aiui.chat(messages)).not_to be_nil
      end
    end

    context 'when passing invalid parameters' do
      let(:messages) { [] }

      it 'should return an error' do
        expect(aiui.chat(messages).to_h).to include(:text)
      end
    end

  end
end