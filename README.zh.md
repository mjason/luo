# Luo
是一款基于大模型的开发框架（面向产品经理），当前支持大模型提供商有: OpenAI、星火大模型。通过DSL能够快速创作并且测试大模型的效果。

## 安装
```
gem install luo
```

## 环境变量说明
```Bash
OPENAI_ACCESS_TOKEN= # OpenAI的访问令牌
OPENAI_TEMPERATURE= # OpenAI的温度
OPENAI_LIMIT_HISTORY= # OpenAI的历史限制
AIUI_APP_KEY= # AIUI的AppKey
AIUI_APP_ID= # AIUI的AppId
XINGHUO_ACCESS_TOKEN= # 星火大模型的访问令牌
```
可以写在项目中的.env也可以放到系统环境变量中。

## 使用

### Hello World


## 补充资源
1. 基于embedding的知识库对话机器人：https://github.com/ankane/neighbor#openai-embeddings
```ruby
def fetch_embeddings(input)
  Luo::OpenAI.new.create_embeddings(input)
end
```