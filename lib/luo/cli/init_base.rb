# frozen_string_literal: true

module Luo
  module CLI
    class InitBase < Thor::Group
      include Thor::Actions
      def create_dirtories
        say "Creating directories...", :green
        empty_directory("prompts")
        empty_directory("agents")
      end

      def copy_files
        say "Copying OpenAI Prompts...", :green
        copy_file "prompts/agent_input.md.erb", "prompts/agent_input.md.erb"
        copy_file "prompts/agent_system.md.erb", "prompts/agent_system.md.erb"
        copy_file "prompts/agent_tool_input.md.erb", "prompts/agent_tool_input.md.erb"

        say "Copying Xinghuo Prompts...", :green
        copy_file "prompts/xinghuo_agent_input.md.erb", "prompts/xinghuo_agent_input.md.erb"
        copy_file "prompts/xinghuo_response_error.md.erb", "prompts/xinghuo_response_error.md.erb"
      end

      def copy_agents
        say "Copying Agents Demo...", :green
        copy_file "time_agent.rb", "agents/time_agent.rb"
        copy_file "weather_agent.rb", "agents/weather_agent.rb"
      end

      def copy_env
        say "Copying luo.env...", :green
        copy_file "env", "luo.env"
      end

      def copy_test_file
        say "Copying test file...", :green
        copy_file "test.yml", "test.yml"
      end

      def self.source_root
        Pathname.new(File.join(__dir__, "../../../templates")).expand_path
      end
    end
  end
end
