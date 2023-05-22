# frozen_string_literal: true

module Luo
  class ParserMarkdown
    def initialize(text)
      @renderer = CustomRenderer.new
      @markdown = Redcarpet::Markdown.new(@renderer, fenced_code_blocks: true)
      @text = text

      parse @text
    end

    def code
      @renderer.code
    end

    def language
      @renderer.language
    end

    def parse(text)
      @markdown.render(text)
    end

    class CustomRenderer < Redcarpet::Render::HTML
      attr_reader :code, :language

      def block_code(code, language)
        @code = code
        @language = language
      end
    end
  end
end
