# frozen_string_literal: true

require 'tmpdir'
require_relative 'serde/serializer_generator.rb'

trace = TracePoint.new(:end) do |tp|
  klass = tp.self
  if Serde::Serializer.descendants.include?(klass)
    klass.compile!
  end
end
trace.enable

module Serde
  class Serializer
    Boolean = 'Boolean' # rubocop:disable Naming/ConstantName

    @descendants = []
    @compiled = false

    class << self
      attr_reader :descendants

      def inherited(klass)
        @descendants << klass
      end

      def schema(**attrs)
        @schema = attrs
      end

      def compile!
        raise 'already compiled' if @compiled

        Dir.mktmpdir do |dir|
          Dir.chdir(dir) do
            SerializerGenerator.call(dir, self)

            rust_path = File.expand_path('../rust', __dir__)

            `cd #{rust_path}; cargo +beta build --release`
            `cp #{rust_path}/target/release/libserde_rb*.a #{dir}/serde_rb/libserde_rb.a`
            `cd #{dir}/serde_rb; ruby extconf.rb; make clean; make`

            require_relative "#{dir}/serde_rb/serde_rb"
          end
        end

        @compiled = true
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
