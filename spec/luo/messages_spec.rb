# frozen_string_literal: true

require 'rspec'

RSpec.describe Luo::Messages do
  let(:messages) { Luo::Messages.create }

  describe '#system' do
    context 'when passing text' do
      it 'should add system message' do
        expect(messages.system(text: 'System message')).to eq(messages)
        expect(messages.to_a).to eq([{role: 'system', content: 'System message'}])
      end
    end

    context 'when passing a file' do
      let(:file) { File.join(File.dirname(__FILE__), 'fixtures', 'system_message.txt') }

      it 'should add system message' do
        expect(messages.system(file: file)).to eq(messages)
        expect(messages.to_a).to eq([{role: 'system', content: "System message from file"}])
      end
    end
  end

  describe '#user' do
    context 'when passing text' do
      it 'should add user message' do
        expect(messages.user(text: 'User message')).to eq(messages)
        expect(messages.to_a).to eq([{role: 'user', content: 'User message'}])
      end
    end

    context 'when passing a file' do
      let(:file) { File.join(File.dirname(__FILE__), 'fixtures', 'user_message.txt') }

      it 'should add user message' do
        expect(messages.user(file: file)).to eq(messages)
        expect(messages.to_a).to eq([{role: 'user', content: "User message from file"}])
      end
    end
  end

  describe '#assistant' do
    context 'when passing text' do
      it 'should add assistant message' do
        expect(messages.assistant(text: 'Assistant message')).to eq(messages)
        expect(messages.to_a).to eq([{role: 'assistant', content: 'Assistant message'}])
      end
    end

    context 'when passing a file' do
      let(:file) { File.join(File.dirname(__FILE__), 'fixtures', 'assistant_message.txt') }

      it 'should add assistant message' do
        expect(messages.assistant(file: file)).to eq(messages)
        expect(messages.to_a).to eq([{role: 'assistant', content: "Assistant message from file"}])
      end
    end
  end

  describe '#to_a' do
    context 'when only user messages added' do
      it 'should return an array of user messages' do
        messages.user(text: 'User message')
        expect(messages.to_a).to eq([{role: 'user', content: 'User message'}])
      end
    end

    context 'when system message and user messages added' do
      it 'should return an array with system message at first' do
        messages.user(text: 'User message')
        messages.system(text: 'System message')
        expect(messages.to_a).to eq([{role: 'system', content: 'System message'}, {role: 'user', content: 'User message'}])
      end
    end
  end
end
