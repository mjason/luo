# Luo
是一款基于大模型的开发框架（面向产品经理），当前支持大模型提供商有: OpenAI、星火大模型。通过DSL能够快速创作并且测试大模型的效果。

## 安装

### 
```
gem install luo
```

###
把下面这行代码添加到 ~/.zshrc 或者 ~/.bashrc 中

```
alias luo = 'docker run --rm -it -v "$PWD:/workdir" ghcr.io/mjason/luo:latest'
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
1. mkdir demo
2. cd demo
3. luo init
4. 修改 .env 的环境变量
5. ruby application.rb

### Messages 说明
```ruby
# 创建一个 Messages 实例
messages = Luo::Messages.create

# 添加用户消息，包含文本内容和提示信息
messages.user(text: "Hello, world!", prompt: TTY::Prompt.new.ask("What's your name?"))

# 添加助手消息，来自文件
messages.assistant(file: 'welcome.md')

# 添加系统消息，包含文本内容和上下文信息
messages.system(text: "User logged in", context: { user_id: 123 })

# 将消息转换为数组并打印出来
puts messages.to_a.inspect

# 输出
[
  {:role=>"system", :content=>"User logged in"},
  {:role=>"user", :content=>"Hello, world!"},
  {:role=>"assistant", :content=>"Welcome to our app!\n"}
]
```
注意：星火大模型的消息类型只支持：user、assistant

## History
Luo 内置了 MemoryHistory 用于处理用户历史对话记录
```ruby
history = Luo::MemoryHistory.new
history.user("Hello, world!")
history.assistant("Welcome to our app!")
puts history.to_a.inspect

# 输出
[
  {:role=>"user", :content=>"Hello, world!"},
  {:role=>"assistant", :content=>"Welcome to our app!"}
]

# 可以在 Messages 使用
messages = Luo::Messages.create(history: history)
```

## Helpers
`Luo::Helpers` 模块是一个包含了一些辅助方法的模块，可以在不同的上下文中重用这些方法。其中，包括了 `print_md` 和 `load_test` 两个方法。

`print_md` 方法用于将 Markdown 格式的文本转换为终端友好的格式，并打印出来。这个方法接受一个参数 `text`，表示需要转换和打印的 Markdown 格式的文本。使用 `print_md` 方法的示例代码如下：

```ruby
text = "# Hello, world!\n\nThis is a **Markdown** text."
Luo::Helpers.print_md(text)
```

在上面的示例中，首先定义了一个 Markdown 格式的文本 `text`，然后使用 `print_md` 方法将其转换为终端友好的格式，并打印出来。

`load_test` 方法用于从 YAML 格式的文件中加载测试数据，并对每个测试数据执行指定的块。这个方法接受两个参数：`path` 和块 `block`。其中 `path` 表示 YAML 文件的路径，块 `block` 表示对每个测试数据要执行的操作。使用 `load_test` 方法的示例代码如下：

```ruby
Luo::Helpers.load_test('tests.yml') do |test_data|
  # 对每个测试数据执行的操作
  puts test_data.inspect
end
```
在上面的示例中，我们使用 `load_test` 方法从 `tests.yml` 文件中加载测试数据，并使用块对每个测试数据进行操作。在这个示例中，我们只是简单地使用 `puts` 方法打印出每个测试数据的内容。实际使用中，块 `block` 可以根据需要执行更复杂的操作，例如执行测试用例、生成报告等。

## 补充资源
1. 基于embedding的知识库对话机器人：https://github.com/ankane/neighbor#openai-embeddings
```ruby
def fetch_embeddings(input)
  Luo::OpenAI.new.create_embeddings(input)
end
```