# frozen_string_literal: true

# require_relative "luo/version"

require 'http'
require 'erb'
require 'dotenv/load'

require "zeitwerk"
loader = Zeitwerk::Loader.for_gem
loader.setup

module Luo
  class Error < StandardError; end
  # Your code goes here...
end
