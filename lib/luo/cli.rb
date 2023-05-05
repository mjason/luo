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

      class Commit < Dry::CLI::Command
        desc "Commit with Luo"

        argument :message, desc: "Commit message", required: true, type: :string

        def call(message:, **)
          messages = Messages.create.system(prompt: Luo::Prompts.luo_commit, context: {commit: message}).to_a
          response = OpenAI.new.chat(messages)
          exec "git commit -m '#{response}'"
        end
      end

      register "version", Version, aliases: %w[v -v --version]
      register "commit", Commit, aliases: ["c"]
    end

  end
end
