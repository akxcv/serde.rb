# frozen_string_literal: true

require 'erb'

def underscore(str)
  str.tr('::', '/')
     .gsub(/([A-Z]+)([A-Z][a-z])/, '\1_\2')
     .gsub(/([a-z\d])([A-Z])/, '\1_\2')
     .tr('-', '_')
     .downcase
end

def generate_serializers # rubocop:disable Metrics/MethodLength
  modules = []

  Serde.subclasses.each do |klass|
    schema = klass.instance_variable_get(:@schema)
    raise 'pls define a schema' if schema.nil?

    module_name = underscore(klass.name)
    fields = schema.map do |k, v|
      type =
        case v.to_s
        when 'Integer' then 'i64'
        when 'Float' then 'f64'
        else v.to_s
        end
      { name: k, type: type }
    end

    modules << {
      class_name: klass.name,
      name: module_name,
      fields: fields,
      joint_fields: fields.map do |field|
        "#{field[:name]}: #{field[:type]}"
      end.join(', ')
    }

    mod_template = ERB.new(File.read('./rust_template/mod.rs.erb'))
    compiled_template = mod_template.result(binding)

    File.open("./src/#{module_name}.rs", 'w') { |f| f.write(compiled_template) }
  end

  lib_template = ERB.new(File.read('./rust_template/lib.rs.erb'))
  compiled_template = lib_template.result(binding)

  File.open('./src/lib.rs', 'w') { |f| f.write(compiled_template) }

  `rake build`
end
