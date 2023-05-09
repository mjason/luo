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
    before do
      allow(FileUtils).to receive(:cp_r)
    end

    it "does not copy the template files if the templates directory already exists" do
      allow(File).to receive(:directory?).with("templates").and_return(true)
      expect(FileUtils).not_to receive(:cp_r)
      Luo::InitProject.create_templates
    end
  end

  describe ".create_agent_directory" do
    it "creates the agents directory" do
      expect(FileUtils).to receive(:mkdir_p).with("agents")
      Luo::InitProject.create_agent_directory
    end
  end

  describe ".create_application" do
    before do
      allow(Luo::InitProject).to receive(:copy_file)
    end

    it "creates the application files and copies the template files" do
      expect(Luo::InitProject).to receive(:copy_file).with("init.rb", "init.rb")
      expect(Luo::InitProject).to receive(:copy_file).with("application.rb", "application.rb")
      expect(Luo::InitProject).to receive(:copy_file).with("env", ".env")
      expect(Luo::InitProject).to receive(:copy_file).with("time_agent.rb", "agents/time_agent.rb")
      expect(Luo::InitProject).to receive(:copy_file).with("weather_agent.rb", "agents/weather_agent.rb")
      expect(Luo::InitProject).to receive(:copy_file).with("test.yml", "test.yml")
      Luo::InitProject.create_application
    end
  end

  describe ".run" do

    it "executes the necessary methods to initialize a project" do
      expect(Luo::InitProject).to receive(:create_bundle_file)
      expect(Luo::InitProject).to receive(:create_templates)
      expect(Luo::InitProject).to receive(:create_agent_directory)
      expect(Luo::InitProject).to receive(:create_application)
      Luo::InitProject.run
    end
  end
end


