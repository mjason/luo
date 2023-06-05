# frozen_string_literal: true

module Luo::LLM
  class Spark
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


    PARAMS = Dry::Schema.Params do
      required(:auditing).filled(:string)
      required(:messages).filled(:array)
      optional(:domain).maybe(:string)
      optional(:max_tokens).maybe(:integer)
      optional(:random_threshold).maybe(:float)
      optional(:uid).maybe(:string)
      optional(:stream).maybe(:bool)
    end

    EMBEDDING_PARAMS = Dry::Schema.Params do
      required(:input).filled(:string)
    end

    # header uid max length is 32 todo

    def request_chat(params, &block)
      client.post('/v1/spark/completions', params.to_h, &block)
    end

    def embedding(params)
      client.post('/v1/embedding', params.to_h)
    end

    def create_embedding(text, model: 'text-embedding-ada-002')
      params = EMBEDDING_PARAMS.call(input: text)
      return params.errors unless params.success?
      response = embedding(params)
      if response.success?
        response.body.dig("data")
      else
        raise "create_embeddings failed: #{response.body}"
      end
    end

    def chat(messages, random_threshold: nil, &block)
      if messages.is_a?(Luo::Messages)
        messages = messages.to_a
      end
      params = PARAMS.call(
        auditing: config.auditing,
        domain: config.domain,
        messages: messages,
        max_tokens: config.max_tokens,
        random_threshold: random_threshold || config.random_threshold,
        uid: config.uid.call,
        stream: block_given?
      )
      return params.errors unless params.success?

      body = {}
      if block_given?
        content = ""
        response = request_chat(params) do |req|
          req.options.on_data = Proc.new do |chunk, *|
            if chunk =~ /data: (.+?)\n(?!data: \[DONE\])/
              json = JSON.parse($1)
              content += json.dig('choices', 0, 'delta', 'content')
              body.merge!(json)
            end
            block.call(chunk)
          end
        end
        body['choices'][0]['delta']['content'] = content
        body['choices'][0]['message'] = body['choices'][0].delete('delta')
      else
        response = request_chat(params)
      end

      if response.success?
        body = response.body if body.empty?
        body.dig('choices', 0, 'message', 'content')
      else
        raise "request_chat failed: #{response.body}"
      end
    end

    class << self
      def llm_func_adapter
        client = self.new
        Proc.new do |messages, temperature|
          client.chat(messages, random_threshold: temperature)
        end
      end

      def llm_func_adapter_stream
        client = self.new
        Proc.new do |messages, temperature|
          client.chat(messages, random_threshold: temperature) do |chunk|
            yield chunk
          end
        end
      end
    end

  end
end
