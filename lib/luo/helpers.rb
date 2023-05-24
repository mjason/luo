# frozen_string_literal: true

module Luo
  module Helpers

    class HTMLwithRouge < Redcarpet::Render::HTML

      def block_code(code, language)
        lexer = Rouge::Lexer.find(language) || Rouge::Lexers::PlainText
        formatter = Rouge::Formatters::HTML.new
        highlighted_code = formatter.format(lexer.lex(code))
        "<pre class=\"highlight\">#{highlighted_code}</pre>"
      end
    end

    extend self

    def print_md(text)
      puts TTY::Markdown.parse(text)
    end

    def display_md(text)
      unless gem_exists?('iruby')
        raise "Please install iruby gem first."
      end

      if gem_exists?('rouge')
        renderer = HTMLwithRouge.new
      else
        renderer = Redcarpet::Render::HTML.new
      end

      markdown = Redcarpet::Markdown.new(renderer,
                                         autolink: true,
                                         tables: true,
                                         strikethrough: true,
                                         highlight: true,
                                         prettify: true,
                                         fenced_code_blocks: true)
      body = markdown.render(text)
      css = Rouge::Themes::Github.mode(:light).render(scope: '.highlight')
      html = <<~HTML
        <style>#{css}</style>
        #{body}
      HTML
      # puts html
      IRuby.display(IRuby.html(html))
    end

    def display_html(text)
      unless gem_exists?('iruby')
        raise "Please install iruby gem first."
      end
      IRuby.display(IRuby.html(text))
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

    def gem_exists?(gem_name)
      Gem::Specification.find_by_name(gem_name)
      true
    rescue Gem::LoadError
      false
    end

  end
end
