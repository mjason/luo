# frozen_string_literal: true

module Luo
  module HttpClient
    def self.init_client
      Module.new do
        define_method :client do
          @client ||= Faraday.new(self.class.config.host) { |conn|
            conn.request :authorization, 'Bearer', self.class.config.access_token if self.class.config.respond_to?(:access_token) && !self.class.config.access_token.nil?
            conn.request :retry, max: (self.class.config.retries || 3), interval: 0.05,
                         interval_randomness: 0.5, backoff_factor: 2,
                         exceptions: [Faraday::TimeoutError, Faraday::ConnectionFailed]
            conn.request :json
            conn.response :json
          }
        end
      end
    end

  end
end
