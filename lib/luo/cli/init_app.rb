# frozen_string_literal: true

module Luo
  module CLI
    class InitApp < InitBase
      def copy_app
        say "Copying App...", :green
        copy_file "application.rb", "app.rb"
      end
    end
  end
end
