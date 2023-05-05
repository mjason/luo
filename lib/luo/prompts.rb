# frozen_string_literal: true

module Luo
  module Prompts
    TEMPLATES_DIR = "#{__dir__}/templates"
    PWD = ENV['LUO_ENV'] == 'test' ? "#{Dir.pwd}/spec/luo" : Dir.pwd
    RUNTIME_TEMPLATES_DIR = "#{PWD}/templates"

    extend self

    def define_templates
      define_templates_in_dir(TEMPLATES_DIR)
      define_templates_in_dir(RUNTIME_TEMPLATES_DIR)
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

