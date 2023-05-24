# frozen_string_literal: true

require_relative "lib/luo/version"

Gem::Specification.new do |spec|
  spec.name = "luo"
  spec.version = Luo::VERSION
  spec.authors = ["MJ"]
  spec.email = ["tywf91@gmail.com"]

  spec.summary = "用来做大模型的开发工具集"
  spec.description = "提供一套API快速开发大模型应用"
  spec.homepage = "https://github.com/mjason/luo"
  spec.required_ruby_version = ">= 2.7.0"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = spec.homepage
  spec.metadata["changelog_uri"] = spec.homepage

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(__dir__) do
    `git ls-files -z`.split("\x0").reject do |f|
      (f == __FILE__) || f.match(%r{\A(?:(?:bin|test|spec|features)/|\.(?:git|circleci)|appveyor)})
    end
  end
  spec.bindir = "exe"
  spec.executables = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  # Uncomment to register a new dependency of your gem
  spec.add_dependency 'zeitwerk', '~> 2.6', '>= 2.6.8'
  spec.add_dependency 'dotenv', '~> 2.8', '>= 2.8.1'
  spec.add_dependency 'faraday', '~> 2.7', '>= 2.7.4'
  spec.add_dependency 'faraday-retry', '~> 2.1'
  spec.add_dependency 'dry-schema', '~> 1.13', '>= 1.13.1'
  spec.add_dependency 'dry-configurable', '~> 1.0', '>= 1.0.1'
  spec.add_dependency 'tty-markdown', '~> 0.7.2'
  spec.add_dependency 'redcarpet', '~> 3.6'
  spec.add_dependency 'rouge', '~> 4.1', '>= 4.1.1'
  spec.add_dependency 'thor', '~> 1.2', '>= 1.2.2'

  spec.add_development_dependency "rspec", '~> 3.12'


  # For more information and examples about making a new gem, check out our
  # guide at: https://bundler.io/guides/creating_gem.html
end
