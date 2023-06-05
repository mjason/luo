# frozen_string_literal: true

module Luo
  class Xinghuo < LLM::Spark

    class << self
      extend Gem::Deprecate

      deprecate :new, :'Luo::LLM::Spark.new', 2023, 8
    end
  end
end
