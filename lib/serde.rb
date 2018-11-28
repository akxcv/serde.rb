# frozen_string_literal: true

require 'tmpdir'
require_relative 'serde/serializer_generator.rb'

module Serde
  class Serializer
    class << self
      def schema(**attrs)
        @schema = attrs

        Dir.mktmpdir do |dir|
          Dir.chdir(dir) do
            SerializerGenerator.call(dir, self)

            rust_path = File.expand_path('../rust', __dir__)

            `cd #{rust_path}; cargo build --release`
            `cp #{rust_path}/target/release/libserde_rb*.a #{dir}/serde_rb/libserde_rb.a`
            `cd #{dir}/serde_rb; ruby extconf.rb; make clean; make`

            require_relative "#{dir}/serde_rb/serde_rb"
          end
        end
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
