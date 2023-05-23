# frozen_string_literal: true

module Luo
  class Marqo
    include Configurable
    setting :host, default: "http://localhost:8882"
    setting :x_api_key, default: nil
    setting :retries, default: 3

    include HttpClient.init_client(headers: { 'X-API-KEY' => config.x_api_key })

    SEARCH_PARAMS = Dry::Schema.Params do
      required(:q).filled(:string)
      optional(:limit).maybe(:integer)
      optional(:offset).maybe(:integer)
      optional(:filter).maybe(:string)
      optional(:searchableAttributes).maybe(:array)
      optional(:showHighlights).maybe(:bool)
      optional(:searchMethod).value(included_in?: %w[TENSOR LEXICAL])
      optional(:attributesToRetrieve).maybe(:array)
      optional(:reRanker).maybe(:string)
      optional(:boost).maybe(:hash)
      optional(:image_download_headers).maybe(:hash)
      optional(:context).maybe(:hash)
      optional(:scoreModifiers).maybe(:hash)
      optional(:modelAuth).maybe(:hash)
    end

    def index(index_name)
      @index_name = index_name
      self
    end

    ##
    # 添加文档到向量数据库
    def add_documents(hash, non_tensor_fields: nil)
      client.post("/indexes/#{@index_name}/documents") do |req|
        req.params[:non_tensor_fields] = non_tensor_fields unless non_tensor_fields.nil?
        req.body = hash
      end
    end

    def refresh
      client.post("/indexes/#{@index_name}/refresh")
    end

    def search(params)
      params = SEARCH_PARAMS.call(params)
      return params.errors unless params.success?
      client.post("/indexes/#{@index_name}/search", params.to_h)
    end

    def delete(id_or_ids)
      id_or_ids = [id_or_ids] if id_or_ids.is_a?(String)
      client.post("/indexes/#{@index_name}/documents/delete-batch", id_or_ids)
    end

    def remove
      client.delete("/indexes/#{@index_name}")
    end
  end
end
