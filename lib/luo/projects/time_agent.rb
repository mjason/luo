class TimeAgent < Agent
  agent_name '时间查询'
  agent_desc '查询当前时间'

  on_call_with_fallback do
    Helpers.print_md "** call aiui time **"
    messages = Luo::Messages.create.user(text: context.user_input)
    response = Luo::AIUI.new.chat(messages)
    response&.dig("text")
  end
end