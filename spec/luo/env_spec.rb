# frozen_string_literal: true

require 'rspec'

RSpec.describe Luo::Env do
  describe '#get' do
    it 'should return the value of an existing environment variable' do
      expect(Luo::Env.get('OPENAI_ACCESS_TOKEN')).not_to be_nil
    end

    it 'should return nil for a non-existent environment variable' do
      expect(Luo::Env.get('NON_EXISTENT_VARIABLE')).to be_nil
    end
  end

  describe '#set' do
    it 'should set the value of an existing environment variable' do
      Luo::Env.set('OPENAI_ACCESS_TOKEN', 'new_value')
      expect(Luo::Env.get('OPENAI_ACCESS_TOKEN')).to eq 'new_value'
    end

    it 'should create a new environment variable' do
      Luo::Env.set('NEW_VARIABLE', 'value')
      expect(Luo::Env.get('NEW_VARIABLE')).to eq 'value'
    end
  end
end
