# frozen_string_literal: true

require 'rspec'

RSpec.describe 'Luo::Helpers' do
  include Luo::Helpers

  it 'should print markdown' do
    print_md('**hello**')
  end

  it('should load test') {
    load_test(File.join(__dir__, 'fixtures/test.yml')) do |value|
      expect(value).not_to be_nil
    end
  }
end
