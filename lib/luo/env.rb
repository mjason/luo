# frozen_string_literal: true

module Luo
  class Env
    ENV_KEY = %w[OPENAI_ACCESS_TOKEN OPENAI_TEMPERATURE OPENAI_LIMIT_HISTORY
                            LOG_LEVEL AIUI_APP_KEY AIUI_APP_ID XINGHUO_ACCESS_TOKEN]
    ENV_KEY.each do |key, value|
      class_variable_set("@@#{key.downcase}", ENV[key])
    end

    def self.get(key)
      class_variable_get("@@#{key.downcase}")
    rescue NameError
      nil
    end

    def self.set(key, value)
      class_variable_set("@@#{key.downcase}", value)
    end
  end
end
