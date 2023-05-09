# frozen_string_literal: true

module Luo
  module InitProject
    extend self

    def project_template_file(name)
      File.join(File.dirname(__FILE__), 'projects', name)
    end
    def create_bundle_file()
      puts "create Gemfile"
      unless File.exist?('Gemfile')
        File.open('Gemfile', 'w') do |file|
          file.puts("source 'https://rubygems.org'")
          file.puts("gem 'luo', '~> 0.1.5'")
        end
      end
    end

    def create_templates
      puts "create templates directory"
      FileUtils.mkdir_p('templates')
    end

    def agent_directory
      puts "create agent directory"
      FileUtils.mkdir_p('agents')
    end

    def create_application
      puts "create application"
      copy_file('init.rb', 'init.rb')
      copy_file('application.rb', 'application.rb')
      copy_file('env', '.env')
      copy_file('time_agent.rb', 'agents/time_agent.rb')
      copy_file('water_agent.rb', 'agents/water_agent.rb')
    end

    def copy_file(file_name, target_file_name)
      puts "copy #{file_name} to #{target_file_name}"
      FileUtils.copy_file(project_template_file(file_name), target_file_name)
    end

    def run()
      create_bundle_file
      create_templates
      create_application
    end

  end
end
