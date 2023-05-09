# frozen_string_literal: true

require 'rspec'

RSpec.describe Luo::InitProject do

  describe ".create_bundle_file" do
    it "creates Gemfile if it does not exist" do
      allow(File).to receive(:exist?).with("Gemfile").and_return(false)
      expect(File).to receive(:open).with("Gemfile", "w")
      Luo::InitProject.create_bundle_file
    end
  end

  describe ".create_templates" do
    it "creates the templates directory" do
      expect(FileUtils).to receive(:mkdir_p).with("templates")
      Luo::InitProject.create_templates
    end
  end

  describe ".agent_directory" do
    it "creates the agents directory" do
      expect(FileUtils).to receive(:mkdir_p).with("agents")
      Luo::InitProject.agent_directory
    end
  end

  describe ".create_application" do
    before do
      allow(Luo::InitProject).to receive(:copy_file)
    end

    it "creates the application files" do
      expect(Luo::InitProject).to receive(:copy_file).with("init.rb", "init.rb")
      expect(Luo::InitProject).to receive(:copy_file).with("application.rb", "application.rb")
      expect(Luo::InitProject).to receive(:copy_file).with("env", ".env")
      expect(Luo::InitProject).to receive(:copy_file).with("time_agent.rb", "agents/time_agent.rb")
      expect(Luo::InitProject).to receive(:copy_file).with("water_agent.rb", "agents/water_agent.rb")
      Luo::InitProject.create_application
    end
  end
  
  describe ".run" do
    it "executes the necessary methods to initialize a project" do
      expect(Luo::InitProject).to receive(:create_bundle_file)
      expect(Luo::InitProject).to receive(:create_templates)
      expect(Luo::InitProject).to receive(:create_application)
      Luo::InitProject.run
    end
  end
end


