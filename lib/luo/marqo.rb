# frozen_string_literal: true

module Luo
  # @deprecated
  class Marqo < LLM::Marqo
    class << self
      extend Gem::Deprecate

      deprecate :new, :'Luo::Client::Marqo.new', 2023, 8
    end
  end
end
