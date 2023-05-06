# frozen_string_literal: true

module Luo
  module Helpers
    extend self

    def print_md(text)
      puts TTY::Markdown.parse(text)
    end

    def load_test(path, &block)
      YAML.load_file(path).each do |value|
        yield(value)
      end
    end

  end
end
