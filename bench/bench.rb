# frozen_string_literal: true

require 'bundler/setup'

require 'benchmark/ips'
require 'serde'
require 'surrealist'

class User
  attr_reader :id, :first_name, :last_name, :email, :age, :admin, :balance

  def initialize(id, first_name, last_name, email, age, admin, balance)
    @id = id
    @first_name = first_name
    @last_name = last_name
    @email = email
    @age = age
    @admin = admin
    @balance = balance
  end
end

class UserSerdeSerializer < Serde::Serializer
  schema(
    id: Integer,
    first_name: String,
    last_name: String,
    email: String,
    age: Integer,
    admin: Boolean,
    balance: Float,
  )
end

class UserSurrealistSerializer < Surrealist::Serializer
  json_schema do
    {
      id: Integer,
      first_name: String,
      last_name: String,
      email: String,
      age: Integer,
      admin: Bool,
      balance: Float,
    }
  end
end

class UserOjSerializer
  def initialize(user)
    @user = user
    @hsh = %w[id first_name last_name email age admin balance].each_with_object({}) do |a, hsh|
      hsh[a] = user.public_send(a)
    end
  end

  def to_json
    Oj.dump(@hsh)
  end
end

user = User.new(1, 'Pavel', 'Yakimov', 'mrpavel@example.com', 24, true, 9123012.412)
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
#                serde    69.276k i/100ms
#           Surrealist     2.623k i/100ms
#                   Oj    70.045k i/100ms
# Calculating -------------------------------------
#                serde    848.515k (± 3.1%) i/s -      4.295M in   5.067076s
#           Surrealist     26.971k (± 1.9%) i/s -    136.396k in   5.058875s
#                   Oj    853.367k (± 2.3%) i/s -      4.273M in   5.009609s

# Comparison:
#                   Oj:   853366.6 i/s
#                serde:   848515.2 i/s - same-ish: difference falls within error
#           Surrealist:    26971.2 i/s - 31.64x  slower

# -------
# Initialize + serialize to JSON
# -------
# Warming up --------------------------------------
