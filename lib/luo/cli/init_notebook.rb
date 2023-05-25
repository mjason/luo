# frozen_string_literal: true

module Luo
  module CLI
    class InitNotebook < InitBase

      desc "Initialize a notebook project"
      def copy_notebook
        say "Copying Notebook...", :green
        copy_file "luo.ipynb", "luo.ipynb"
      end

      def copy_gemfile
        say "Copying Gemfile...", :green
        template "NotebookGemfile.erb", "Gemfile"
      end

    end
  end
end
