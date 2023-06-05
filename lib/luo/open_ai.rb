# frozen_string_literal: true

module Luo
  class OpenAI < LLM::OpenAI
    class << self
      extend Gem::Deprecate

      deprecate :new, :'Luo::LLM::OpenAI.new', 2023, 8
    end
  end
end
