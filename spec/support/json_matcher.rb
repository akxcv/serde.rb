# frozen_string_literal: true

module Serde
  module Matchers
    def eq_json(expected)
      expected = Hash[expected.map{ |k, v| [k.to_s, v] }]
      EqJson.new(expected)
    end

    class EqJson
      include RSpec::Matchers

      def initialize(expected)
        @expected = expected
      end

      def matches?(actual)
        @matcher = a_hash_including(expected)
        matcher.matches?(JSON.parse(actual))
      end

      def failure_message
        matcher.failure_message
      end

      private

      attr_reader :expected, :matcher
    end
  end
end
