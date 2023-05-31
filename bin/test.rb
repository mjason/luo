# # frozen_string_literal: true
require "bundler/setup"
require "luo"

history = Luo::MemoryHistory.new

prompt = Luo::PromptTemplate.new(text: "<%= input %>")
cain = Luo::LLMFunc.cain
                   .prompt(prompt)
                   .adapter(Luo::Xinghuo.llm_func_adapter)
                   .use(Luo::Middleware::Logger)
                   .use(Luo::Middleware::MemoryHistory.create(history))

puts cain.call(input: "罗纳尔多是谁")
puts history
puts cain.call(input: "他和齐达内谁厉害")
puts history
binding.irb