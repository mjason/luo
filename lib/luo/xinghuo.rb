# frozen_string_literal: true

module Luo
  class Xinghuo
    include Configurable

    setting :access_token, default: ENV.fetch('LISTENAI_ACCESS_TOKEN')
    setting :retries, default: ENV.fetch('LISTENAI_REQUEST_RETRIES', 3).to_i
    setting :host, default: ENV.fetch('LISTENAI_HOST', 'https://api.listenai.com')
    setting :history_limit, default: ENV.fetch('LISTENAI_LIMIT_HISTORY', '6').to_i * 2
    setting :random_threshold, default: ENV.fetch('LISTENAI_TEMPERATURE', 0).to_i
    setting :auditing, default: 'default'
    setting :domain, default: 'general'
    setting :max_tokens, default: 1024
    setting :uid, default: -> { SecureRandom.hex(16) }

    include HttpClient.init_client

    PARAMS = Dry::Schema.Params do
      required(:auditing).filled(:string)
      required(:messages).filled(:array)
      optional(:domain).maybe(:string)
      optional(:max_tokens).maybe(:integer)
      optional(:random_threshold).maybe(:float)
      optional(:uid).maybe(:string)
    end

    # header uid max length is 32 todo

    def request_chat(params)
      client.post('/v1/spark/completions', params.to_h)
    end

    def chat(messages, random_threshold: nil)
      if messages.is_a?(Messages)
        messages = messages.to_a
      end
      params = PARAMS.call(
        auditing: config.auditing,
        domain: config.domain,
        messages: messages,
        max_tokens: config.max_tokens,
        random_threshold: random_threshold || config.random_threshold,
        uid: config.uid.call
      )
      return params.errors unless params.success?
      request_chat(params).body.dig('choices', 0, 'message', 'content')
    end

    class << self
      def llm_func_adapter
        client = self.new
        Proc.new do |messages, temperature|
          client.chat(messages, random_threshold: temperature)
        end
      end
    end

  end
end
