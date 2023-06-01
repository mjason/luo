require 'luo'

Luo.app_setup do |loader|
  loader.push_dir(File.join(__dir__, 'agents'))
end

class Runner < XinghuoAgentRunner

  setting :stream_callback, default: ->(chunk) { puts chunk }

  register WeatherAgent
  register TimeAgent
  register XinghuoFinalAgent
end

def run_test
  runner = Runner.new

  Helpers.load_test('test.yml') do |input|
    context = runner.call(input)
    Helpers.print_md <<~MD
  ## Input:
  #{input}

  ## Response:
  #{context.response}

  ## Final Result:
  #{context.final_result}

  ## History:
  ```ruby
  #{context.histories.to_a}
  ```
    MD
    puts "\n\n\n"
  end
end

run_test