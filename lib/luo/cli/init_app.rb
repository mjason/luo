# frozen_string_literal: true

module Luo
  module CLI
    class InitApp < InitBase
      def copy_app
        say "Copying App...", :green
        copy_file "application.rb", "app.rb"
      end

      def copy_gemfile
        say "Copying Gemfile...", :green
        template "AppGemfile.erb", "Gemfile"
      end
    end
  end
end
