# frozen_string_literal: true

module Luo
  module Helpers
    extend self

    def print_md(text)
      puts TTY::Markdown.parse(text)
    end

    def load_test(path, &block)
      data = YAML.load_file(path)
      if data.is_a?(Array)
        data.each do |value|
          yield(value)
        end
      else
        yield(data)
      end
    end
  end
end
