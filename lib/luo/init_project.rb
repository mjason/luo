# frozen_string_literal: true

module Luo
  module InitProject
    extend self

    def project_template_file(name)
      File.join(File.dirname(__FILE__), 'projects', name)
    end
    def create_bundle_file()
      puts "create Gemfile"
      version = Luo::VERSION
      unless File.exist?('Gemfile')
        gemfile = <<-GEMFILE.gsub(/^ */, '')
        source 'https://rubygems.org'
        gem 'luo', '~> #{version}'
        gem 'iruby'
        GEMFILE
        File.open('Gemfile', 'w') do |file|
          file.puts(gemfile)
        end
      end
    end

    def create_templates
      puts "create templates directory"
      unless File.directory?('templates')
        FileUtils.cp_r(File.join(__dir__, 'projects', 'prompts'), 'prompts')
      end
    end

    def create_agent_directory
      puts "create agent directory"
      FileUtils.mkdir_p('agents')
    end

    def create_application
      puts "create application"
      copy_file('init.rb', 'init.rb')
      copy_file('application.rb', 'app.rb')
      copy_file('env', '.env')
      copy_file('time_agent.rb', 'agents/time_agent.rb')
      copy_file('weather_agent.rb', 'agents/weather_agent.rb')
      copy_file('luo.ipynb', 'luo.ipynb')
      copy_file("test.yml", "test.yml")
    end

    def copy_file(file_name, target_file_name)
      puts "copy #{file_name} to #{target_file_name}"
      unless File.exist?(target_file_name)
        FileUtils.copy_file(project_template_file(file_name), target_file_name)
      end
    end

    def run()
      create_bundle_file
      create_templates
      create_agent_directory
      create_application

      Helpers.print_md """
      ## Luo Project Initialized
      You can now run `bundle install` to install the dependencies
      and edit .env to add your API key.
      and `bundle exec ruby application.rb` to run the project.
      """
    end

  end
end
