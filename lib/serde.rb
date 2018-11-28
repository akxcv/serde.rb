# frozen_string_literal: true

require 'fileutils'
require_relative 'serde/serializer_generator.rb'

FileUtils.rm_r(Dir.glob('_target_/*'))
FileUtils.cp_r(Dir.glob('templates/extension/*'), '_target_')

module Serde
  class Serializer
    class << self
      def schema(**attrs)
        @schema = attrs
        SerializerGenerator.call(self)
        Dir.chdir(File.expand_path('../_target_', __dir__)) do
          `make`
        end

        require_relative '../_target_/serde_rb/serde_rb'
      end

      def get_schema
        @schema
      end
    end

    def initialize(object)
      @args = self.class.get_schema.keys.map { |k| object.public_send(k) }
    end

    def to_json
      internal_to_json(*@args)
    end
  end
end
