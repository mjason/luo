# frozen_string_literal: true

module Luo
  module HttpClient
    def self.init_client(options={})
      config_proc = ->(it) { it.class.config }
      create_client(config_proc, options)
    end

    def self.init_client_with_instance(options={})
      config_proc = ->(it) { it.config }
      create_client(config_proc, options)
    end

    def self.create_client(config_proc, options={})
      Module.new do
        define_method :client do
          config = config_proc.call(self)

          @client ||= Faraday.new(config.host, options) { |conn|
            conn.request :authorization, 'Bearer', config.access_token if config.respond_to?(:access_token) && !config.access_token.nil?
            conn.request :retry, max: (config.retries || 3), interval: 0.05,
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
