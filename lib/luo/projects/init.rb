# frozen_string_literal: true

require "bundler/setup"
Bundler.require

require 'luo'
include Luo

Loader.push_dir(File.join(__dir__, 'agents'))
Loader.setup