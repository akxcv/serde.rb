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

    context 'type checks' do
      it 'raises a TypeError if given an argument of wrong type' do
        expect { Serializer.new(Subject.new('Some', 'Teapot', 99.99, true)).to_json }
          .to raise_error(TypeError, 'wrong argument type String (expected Fixnum)')
        expect { Serializer.new(Subject.new(100, {}, 99.99, true)).to_json }
          .to raise_error(TypeError, 'wrong argument type Hash (expected String)')
        expect { Serializer.new(Subject.new(100, 'Teapot', 99, true)).to_json }
          .to raise_error(TypeError, 'wrong argument type Integer (expected Float)')
        expect { Serializer.new(Subject.new(100, 'Teapot', 99.99, nil)).to_json }
          .to raise_error(TypeError, 'wrong argument type NilClass (expected Boolean)')
      end
    end
  end
end
