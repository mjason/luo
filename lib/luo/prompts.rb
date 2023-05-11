# frozen_string_literal: true

module Luo
  module Prompts
    extend Dry::Configurable

    setting :gem_templates_dir, default: "#{__dir__}/templates"
    setting :prompts_dir, default: "#{Dir.pwd}/prompts"

    extend self

    def define_templates
      define_templates_in_dir(config.gem_templates_dir)
      define_templates_in_dir(config.prompts_dir)
    end

    def define_templates_in_dir(dir_path)
      Dir.glob("#{dir_path}/*.md.erb") do |file|
        template_name = File.basename(file, '.md.erb').to_sym
        define_template(template_name, file)
      end
    end

    def define_template(template_name, file_path)
      define_method(template_name) do
        PromptTemplate.create(file_path)
      end
    end

    define_templates
  end
end

