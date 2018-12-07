# frozen_string_literal: true

RSpec.describe 'serde.rb' do
  Subject = Struct.new(:id, :name, :price, :available)

  class Serializer < Serde::Serializer
    schema(
      id: Integer,
      name: String,
      price: Float,
      available: Boolean,
    )
  end

  describe 'serialization' do
    context 'basic types' do
      subject { Serializer.new(Subject.new(100, 'Teapot', 99.99, true)).to_json }

      it { is_expected.to eq_json(id: 100, name: 'Teapot', price: 99.99, available: true) }
    end
  end
end
