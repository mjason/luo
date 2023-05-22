# frozen_string_literal: true

require "bundler/setup"
Bundler.require

require 'luo'
include Luo



text = """
# 一级标题
"""
markdown = ParserMarkdown.new(text)
binding.irb