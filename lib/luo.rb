# frozen_string_literal: true

# require_relative "luo/version"

require 'erb'
require 'dotenv'
require 'json'
require 'faraday'
require 'faraday/retry'
require 'dry-configurable'
require 'dry-schema'
require 'yaml'
require 'tty-markdown'
require 'fileutils'
require 'dry-initializer'
require 'uri'
require 'redcarpet'
require 'thor'
require 'logger'

require "zeitwerk"
loader = Zeitwerk::Loader.for_gem
loader.inflector.inflect("open_ai" => "OpenAI")
loader.inflector.inflect("aiui" => "AIUI")
loader.inflector.inflect("cli" => "CLI")
loader.inflector.inflect("open_ai_agent_runner" => "OpenAIAgentRunner")
loader.inflector.inflect("open_ai_runner" => "OpenAIRunner")
loader.inflector.inflect('llm_func' => 'LLMFunc')
loader.inflector.inflect('llm' => 'LLM')
loader.setup

module Luo
  class Error < StandardError; end
  class ClientNotSetError < StandardError; end
  # Your code goes here...

  module_eval do
    Dotenv.load('luo.env', '.env')
  end

  def self.app_setup(&block)
    TOPLEVEL_BINDING.eval('include Luo')
    block.call(Loader) if block_given?
    Loader.setup
  end

  def self.notebook_setup(&block)
    TOPLEVEL_BINDING.eval('include Luo')
    Object.prepend Luo::ErrorHandle if ENV['LUO_ENV'] == 'debug'

    block.call(Loader) if block_given?
    Loader.setup
    if Helpers.gem_exists?('pry')
      require 'pry'
      IRuby::Kernel.instance.switch_backend!(:pry)
    end
  end

end
