# frozen_string_literal: true

module Luo
  class AIUI
    include Configurable

    setting :id, default: ENV.fetch('AIUI_APP_ID')
    setting :key, default: ENV.fetch('AIUI_APP_KEY')
    setting :host, default: 'http://api.iflyos.cn'
    setting :uid, default: -> { SecureRandom.hex(16) }

    include HttpClient.init_client

    PARAMS = Dry::Schema.Params do
      required(:appid).filled(:string)
      required(:appkey).filled(:string)
      required(:uid).filled(:string)
      required(:text).filled(:string)
    end

    def request_aiui(params)
      client.post('/external/ls_log/aiui_request', params.to_h)
    end

    def chat(messages)
      message = messages.last&.fetch(:content, nil)
      params = PARAMS.call(
        appid: config.id,
        appkey: config.key,
        uid: config.uid,
        text: message
      )
      return params.errors unless params.success?
      request_aiui(params).body.dig("data", 0, "intent", "answer")
    end
  end
end
