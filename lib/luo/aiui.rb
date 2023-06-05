# frozen_string_literal: true

module Luo
  class AIUI < Client::AIUI
    class << self
      extend Gem::Deprecate

      deprecate :new, :'Luo::Client::AIUI.new', 2023, 8
    end
  end
end
