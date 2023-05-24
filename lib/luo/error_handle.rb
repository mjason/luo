# frozen_string_literal: true

module Luo
  module ErrorHandle
    def raise(err, *args)
      Luo::ErrorHandle.gpt_error_analyze(err)
      super
    end

    def fail(*args)
      raise(*args)
    end

    def gpt_error_analyze(error)
      if error
        error_message = error.message
        backtrace = error.backtrace

        context = {
          message: error_message,
          backtrace: backtrace
        }
        Helpers.display_md(" **你的代码出错了！正在使用 ChatGPT 分析错误原因，请稍后 ... **")

        messages = Messages.create
                           .system(text: "你是一个ruby专家，根据用户的输入，你需要分析出错误的原因，然后给出解决方案。")
                           .user(prompt: Prompts.luo_error_analyze, context: context)
        response = OpenAI.new.chat(messages)

        Helpers.display_md(response)
        puts "\n"
      end
    end
  end
end
