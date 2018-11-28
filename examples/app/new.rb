# frozen_string_literal: true

require 'bundler/setup'
require 'serde'

module Kek
  class CowSerializer < Serde::Serializer
    schema(
      id: Integer,
      name: String,
    )
  end

  class Cow
    attr_reader :id, :name

    def initialize(id, name)
      @id = id
      @name = name
    end
  end
end

puts Kek::CowSerializer.new(Kek::Cow.new(1, 'Ковыч')).to_json
