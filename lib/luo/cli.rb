# frozen_string_literal: true

module Luo
  module CLI
    module Commands
      extend Dry::CLI::Registry

      class Version < Dry::CLI::Command
        desc "Print version"

        def call(*)
          puts Luo::VERSION
        end
      end

      class Init < Dry::CLI::Command
        desc "Init Luo Project"

        def call(*)
          Luo::InitProject.run
        end
      end

      class Commit < Dry::CLI::Command
        desc "Commit with Luo"

        argument :message, desc: "Commit message", required: true, type: :string

        def call(message:, **)
          messages = Messages.create.system(prompt: Luo::Prompts.luo_commit, context: {commit: message}).to_a
          response = OpenAI.new.chat(messages)
          exec "git commit -m '#{response}'"
        end
      end

      class Run < Dry::CLI::Command
        desc "Run Luo"

        def call(*)
          exec "ruby application.rb"
        end
      end

      class Bundle < Dry::CLI::Command
        desc "Bundle with Luo"

        def call(*)
          exec "bundle install"
        end
      end

      register "version", Version, aliases: %w[v -v --version]
      register "commit", Commit, aliases: ["c"]
      register "init", Init, aliases: ["i"]
      register "run", Run, aliases: ["r"]
      register "bundle", Bundle, aliases: ["b"]

    end

  end
end
