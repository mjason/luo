# frozen_string_literal: true

require 'rspec'

RSpec.describe Luo::OpenAI do
  let(:openai) { Luo::OpenAI.new }

  describe '#chat' do
    let(:messages) { Luo::Messages.create.user(text: "hello").to_a }

    context 'when passing valid parameters' do

      it 'should return a response' do
        expect(openai.chat(messages)).not_to be_nil
      end
    end

    context 'when passing invalid parameters' do
      let(:messages) { [] }

      it 'should return an error' do
        expect(openai.chat(messages).to_h).to include(:messages)
      end
    end

  end

  describe '#create_embedding' do
    let(:text) { "hello world" }

    context 'when passing valid parameters' do

      it 'should return a response' do
        expect(openai.create_embeddings(text)).not_to be_nil
      end
    end

    context 'when passing invalid parameters' do
      let(:text) { nil }

      it 'should return an error' do
        expect(openai.create_embeddings(text).to_h).to include(:input)
      end
    end
  end
end

