# frozen_string_literal: true

module Luo
  class Client
    def chat(messages)
      raise NotImplementedError, "chat method must be implemented in subclass"
    end
  end
end
