# frozen_string_literal: true

require 'rspec'

RSpec.describe Luo::Prompts do
  describe '#define_templates' do
    it 'should define templates' do
      expect(Luo::Prompts).to respond_to(:agent_input)
      expect(Luo::Prompts).to respond_to(:agent_system)
      expect(Luo::Prompts).to respond_to(:agent_tool_input)
      expect(Luo::Prompts).to respond_to(:xinghuo_agent_input)
    end
  end

  describe '#method_missing' do
    context 'when template file exists' do
      let(:template_file) { "#{Dir.pwd}/spec/luo/templates/demo.md.erb" }

      before do
        allow(File).to receive(:exist?).and_return(true)
        allow(subject).to receive(:template_file_path).and_return(template_file)
        subject.send(:method_missing, :my_template)
      end

      it 'defines a new template method' do
        expect(subject.respond_to?(:my_template)).to be true
      end

      it 'returns the prompt template' do
        expect(subject.my_template).to be_a(Luo::PromptTemplate)
      end
    end

    context 'when template file does not exist' do
      before do
        allow(File).to receive(:exist?).and_return(false)
      end

      it 'raises NoMethodError' do
        expect { subject.send(:method_missing, :non_existing_template) }
          .to raise_error(NoMethodError)
      end
    end
  end
end

