# frozen_string_literal: true

require 'bundler/setup'
require 'serde'

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

puts CowSerializer.new(Cow.new(1, 'Ковыч')).to_json
