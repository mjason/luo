# # frozen_string_literal: true
require "bundler/setup"
require "luo"

# cain = Luo::LLMFunc.cain(middlewares: [Luo::Middleware::Log]) do |c|
#   c.prompt = Luo::PromptTemplate.new(text: "你是一个ruby专家，和我一起结对编程\n我希望你能教我<%= skill %>")
#   c.adapter = Luo::Xinghuo.llm_func_adapter
# end
#
# cain.call(skill: "proc怎么做")

env = Luo::Middleware::Env.new name: 'manjia'
binding.irb