# frozen_string_literal: true

require 'bundler/setup'
require 'serde'

module Kek
  class Cow
    attr_reader :id, :name

    def initialize(id, name)
      @id = id
      @name = name
    end
  end

  class CowSerializer < Serde::Serializer
    schema(
      id: Integer,
      name: String,
    )
  end
end

module Pek
  class Car
    attr_reader :id, :brand, :model, :price

    def initialize(id, brand, model, price)
      @id = id
      @brand = brand
      @model = model
      @price = price
    end
  end

  class CarSerializer < Serde::Serializer
    schema(
      id: Integer,
      brand: String,
      model: String,
      price: Float,
    )
  end
end

puts Kek::CowSerializer.new(Kek::Cow.new(1, 'Ковыч')).to_json
puts Pek::CarSerializer.new(Pek::Car.new(1, 'Mazda', '6', 100.01)).to_json
