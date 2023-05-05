# frozen_string_literal: true

# require_relative "luo/version"

require 'erb'
require 'dotenv/load'
require 'json'
require 'faraday'
require 'faraday/retry'
require 'dry-configurable'
require 'dry-schema'
require 'dry/cli'

require "zeitwerk"
loader = Zeitwerk::Loader.for_gem
loader.inflector.inflect("open_ai" => "OpenAI")
loader.inflector.inflect("aiui" => "AIUI")
loader.inflector.inflect("cli" => "CLI")
loader.setup

module Luo
  class Error < StandardError; end
  # Your code goes here...
end
