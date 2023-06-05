# frozen_string_literal: true

module Luo::LLM
  module Configurable
    def self.included(base)
      base.include Dry::Configurable
      base.include Luo::HttpClient.init_client_with_instance
    end


  end
end
