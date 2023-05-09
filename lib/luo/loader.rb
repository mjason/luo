# frozen_string_literal: true

module Luo
  module Loader
    extend self

    def loader
      @loader ||= Zeitwerk::Loader.new
    end

    def push_dir(path)
      loader.push_dir(path)
    end

    def setup
      loader.setup
    end

  end
end
