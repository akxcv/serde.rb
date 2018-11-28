# frozen_string_literal: true

require 'erb'

module Serde
  module SerializerGenerator
    class << self
      def call(klass) # rubocop:disable Metrics/MethodLength
        schema = klass.instance_variable_get(:@schema)

        name = underscore(klass.name)
        fields = schema.map do |k, v|
          v = v.to_s
          type =
            case v
            when 'Integer' then 'i64'
            when 'Float' then 'f64'
            else v
            end
          ctype =
            case v
            when 'Integer' then 'int'
            when 'String' then 'char*'
            end
          cdecl =
            case v
            when 'Integer' then "int c_#{k} = NUM2INT(#{k});"
            when 'String' then "char* c_#{k} = StringValueCStr(#{k});"
            end
          rctype =
            case v
            when 'String' then '*const c_char'
            when 'Integer' then 'i64'
            when 'Float' then 'f64'
            else v
            end
          { name: k, type: type, rctype: rctype, cdecl: cdecl, ctype: ctype }
        end

        serializer = {
          class_name: klass.name,
          name: name,
          fields: fields,
          joint_fields: fields.map do |field|
            "#{field[:name]}: #{field[:type]}"
          end.join(', '),
          joint_fields_rctype: fields.map do |field|
            "#{field[:name]}: #{field[:rctype]}"
          end.join(', '),
          joint_fields_c: fields.map do |field|
            "#{field[:ctype]} #{field[:name]}"
          end.join(', '),
        }

        mod_template = ERB.new(File.read('./templates/rust/mod.rs'))
        compiled_template = mod_template.result(binding)

        File.write("./rust/src/#{name}.rs", compiled_template)

        c_template = ERB.new(File.read('./templates/c/serde_rb.c'))
        compiled_template = c_template.result(binding)

        File.write('./_target_/serde_rb/serde_rb.c', compiled_template)

        lib_template = ERB.new(File.read('./templates/rust/lib.rs'))
        compiled_template = lib_template.result(binding)

        File.write('./rust/src/lib.rs', compiled_template)
      end

      private

      def underscore(str)
        str.tr('::', '__')
           .gsub(/([A-Z]+)([A-Z][a-z])/, '\1_\2')
           .gsub(/([a-z\d])([A-Z])/, '\1_\2')
           .tr('-', '_')
           .downcase
      end
    end
  end
end
