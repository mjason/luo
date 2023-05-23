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

    def method_missing(method_name, *args, &block)
      template_file = template_file_path(method_name)
      if template_file
        define_template(method_name, template_file)
        send(method_name)
      else
        super
      end
    end

    def respond_to_missing?(method_name, include_private = false)
      template_file_path(method_name) || super
    end

    private

    def template_file_path(template_name)
      gem_template_file = "#{config.gem_templates_dir}/#{template_name}.md.erb"
      prompts_template_file = "#{config.prompts_dir}/#{template_name}.md.erb"

      return prompts_template_file if File.exist?(prompts_template_file)
      return gem_template_file if File.exist?(gem_template_file)

      nil
    end

  end
end

