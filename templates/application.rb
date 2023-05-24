require_relative 'init'

class Runner < XinghuoAgentRunner
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