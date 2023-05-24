# frozen_string_literal: true

module Luo
  module CLI
    class APP < Thor

      map %w[--version -v] => :__print_version
      map 'c' => :commit

      desc "--version, -v", "print the version"
      def __print_version
        puts "Luo version #{Luo::VERSION}"
      end

      desc "commit <message>", "git commit with luo"
      def commit(message)
        messages = Messages.create.user(prompt: Luo::Prompts.luo_commit, context: {commit: message}).to_a
        if ENV["LUO_LLM_MODE"] == "openai"
          response = OpenAI.new.chat(messages)
        else
          response = Xinghuo.new.chat(messages)
        end
        exec "git commit -m '#{response}'"
      end

      desc "init", "initialize luo"
      option :type, aliases: "-t", default: "notebook", desc: "type of luo project", enum: %w[notebook app]
      def init
        if options[:type] == "notebook"
          invoke InitNotebook
        elsif options[:type] == "app"
          invoke InitApp
        end
      end

      def self.exit_on_failure?
        if $! && $!.is_a?(Thor::Error)

          command = "luo " + ARGV.join(' ')
          messages = Messages.create.user(prompt: Luo::Prompts.luo_error, context: {error: $!.message, command: command}).to_a
          if ENV["LUO_LLM_MODE"] == "openai"
            response = OpenAI.new.chat(messages)
          else
            response = Xinghuo.new.chat(messages)
          end

          shell = Thor::Shell::Color.new
          shell.say "\n #{response}", :green
        end
        true
      end

    end
  end
end