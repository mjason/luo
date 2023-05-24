# frozen_string_literal: true

class WeatherAgent < Agent
  agent_name '天气查询'
  agent_desc '查询城市的天气情况，穿衣指数，空气质量等'

  on_call_with_fallback do
    Helpers.print_md "** call aiui weather **"
    messages = Luo::Messages.create.user(text: context.user_input)
    response = Luo::AIUI.new.chat(messages)
    response&.dig("text")
  end
end