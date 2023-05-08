# frozen_string_literal: true

module Luo
  class OpenAI
    include Configurable

    setting :access_token, default: ENV.fetch('OPENAI_ACCESS_TOKEN')
    setting :retries, default: ENV.fetch('OPENAI_REQUEST_RETRIES', 3).to_i
    setting :host, default: ENV.fetch('OPENAI_HOST', 'https://api.openai.com')
    setting :temperature, default: ENV.fetch('OPENAI_TEMPERATURE', 1).to_i

    include HttpClient.init_client

    PARAMS = Dry::Schema.Params do
      required(:model).filled(:string)
      required(:temperature).filled(:float)
      required(:messages).filled(:array)
      optional(:top_p).maybe(:float)
      optional(:n).maybe(:integer)
      optional(:stream).maybe(:bool)
      optional(:stop).maybe(:array)
      optional(:max_tokens).maybe(:integer)
      optional(:presence_penalty).maybe(:float)
      optional(:frequency_penalty).maybe(:float)
      optional(:logit_bias).maybe(:hash)
      optional(:user).maybe(:string)
    end

    EMBEDDING_PARAMS = Dry::Schema.Params do
      required(:input).filled(:array)
      required(:model).filled(:string)
    end

    def chat_completions(params)
      client.post('/v1/chat/completions', params.to_h)
    end

    def embeddings(params)
      client.post('/v1/embeddings', params.to_h)
    end

    def create_embeddings(text, model: 'text-embedding-ada-002')
      if text.is_a?(String)
        text = [text]
      end
      params = EMBEDDING_PARAMS.call(input: text, model: model)
      return params.errors unless params.success?
      embeddings(params).body.dig("data").map { |v| v["embedding"] }
    end

    def chat(messages)
      if messages.is_a?(Messages)
        messages = messages.to_a
      end
      params = PARAMS.call(
        model: 'gpt-3.5-turbo',
        temperature: config.temperature,
        messages: messages
      )
      return params.errors unless params.success?
      chat_completions(params).body.dig("choices", 0, "message", "content")
    end

  end

end
