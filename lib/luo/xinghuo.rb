# frozen_string_literal: true

module Luo
  class Xinghuo
    include Configurable

    setting :access_token, default: ENV.fetch('XINGHUO_ACCESS_TOKEN')
    setting :retries, default: ENV.fetch('XINGHUO_REQUEST_RETRIES', 3).to_i
    setting :host, default: ENV.fetch('XINGHUO_HOST', 'https://integration-api.iflyos.cn/')
    setting :history_limit, default: ENV.fetch('XINGHUO_LIMIT_HISTORY', '6').to_i * 2
    setting :temperature, default: ENV.fetch('XINGHUO_TEMPERATURE', 0).to_i
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
    end

    # header uid max length is 32 todo

    def request_chat(params)
      client.post('/external/ls_log/xf_completions', params.to_h)
    end

    def chat(messages)
      params = PARAMS.call(
        auditing: config.auditing,
        domain: config.domain,
        messages: messages,
        max_tokens: config.max_tokens,
        random_threshold: config.temperature,
        uid: config.uid.call
      )
      return params.errors unless params.success?
      request_chat(params).body.dig('choices', 0, 'message', 'content')
    end

  end
end
