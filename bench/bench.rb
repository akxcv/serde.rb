# frozen_string_literal: true

require 'bundler/setup'

require 'benchmark/ips'
require 'serde'
require 'surrealist'

class User
  attr_reader :id, :first_name, :last_name, :email, :age

  def initialize(id, first_name, last_name, email, age)
    @id = id
    @first_name = first_name
    @last_name = last_name
    @email = email
    @age = age
  end
end

class UserSerdeSerializer < Serde::Serializer
  schema(
    id: Integer,
    first_name: String,
    last_name: String,
    email: String,
    age: Integer
  )
end

class UserSurrealistSerializer < Surrealist::Serializer
  json_schema do
    {
      id: Integer,
      first_name: String,
      last_name: String,
      email: String,
      age: Integer
    }
  end
end

class UserOjSerializer
  def initialize(user)
    @user = user
  end

  def to_json
    Oj.dump(
      id: @user.id,
      first_name: @user.first_name,
      last_name: @user.last_name,
      email: @user.email,
      age: @user.age
    )
  end
end

user = User.new(1, 'Pavel', 'Yakimov', 'mrpavel@example.com', 24)
serde_serializer = UserSerdeSerializer.new(user)
surrealist_serializer = UserSurrealistSerializer.new(user)
oj_serializer = UserOjSerializer.new(user)

puts "-------\nSerialize to JSON\n-------"
Benchmark.ips do |x|
  x.report('serde') { serde_serializer.to_json }
  x.report('Surrealist') { surrealist_serializer.surrealize }
  x.report('Oj') { oj_serializer.to_json }

  x.compare!
end

puts "-------\nInitialize + serialize to JSON\n-------"
Benchmark.ips do |x|
  x.report('serde') { UserSerdeSerializer.new(user).to_json }
  x.report('Surrealist') { UserSurrealistSerializer.new(user).surrealize }
  x.report('Oj') { UserOjSerializer.new(user).to_json }

  x.compare!
end

# -------
# Serialize to JSON
# -------
# Warming up --------------------------------------
#                serde    76.802k i/100ms
#           Surrealist     3.064k i/100ms
#                   Oj    51.183k i/100ms
# Calculating -------------------------------------
#                serde    898.268k (± 5.1%) i/s -      4.531M in   5.058080s
#           Surrealist     36.268k (± 3.2%) i/s -    183.840k in   5.074885s
#                   Oj    689.594k (± 3.4%) i/s -      3.480M in   5.053357s

# Comparison:
#                serde:   898267.9 i/s
#                   Oj:   689593.9 i/s - 1.30x  slower
#           Surrealist:    36268.1 i/s - 24.77x  slower

# -------
# Initialize + serialize to JSON
# -------
# Warming up --------------------------------------
#                serde    41.158k i/100ms
#           Surrealist     3.087k i/100ms
#                   Oj    51.710k i/100ms
# Calculating -------------------------------------
#                serde    451.324k (± 1.4%) i/s -      2.264M in   5.016647s
#           Surrealist     33.478k (± 6.8%) i/s -    166.698k in   5.003821s
#                   Oj    635.098k (± 2.9%) i/s -      3.206M in   5.052618s

# Comparison:
#                   Oj:   635097.9 i/s
#                serde:   451323.7 i/s - 1.41x  slower
#           Surrealist:    33478.1 i/s - 18.97x  slower

