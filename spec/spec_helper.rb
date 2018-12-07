# frozen_string_literal: true

require 'bundler/setup'
require 'serde'
require 'pry'

Dir[File.expand_path('../spec/support/**/*.rb', __dir__)].each { |x| require x }
include Serde::Matchers

RSpec.configure do |config|
  config.order = :random
  config.disable_monkey_patching!
  Kernel.srand config.seed
  config.expect_with(:rspec) { |c| c.syntax = :expect }
end
