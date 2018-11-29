# frozen_string_literal: true

lib = File.expand_path('../lib', __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

Gem::Specification.new do |spec|
  spec.required_ruby_version = '>= 2.5.3'

  spec.name    = 'serde'
  spec.version = '0.0.9'
  spec.authors = ['Alexander Komarov']
  spec.email   = %w[ak@akxcv.com]

  spec.summary     = 'Fast, compiled serializers for Ruby.'
  spec.description = 'Fast, compiled serializers for Ruby. Powered by serde.rs.'
  spec.homepage    = 'https://github.com/akxcv/serde.rb'
  spec.license     = 'MIT'

  spec.require_paths = %w[lib]

  spec.files = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end

  spec.add_development_dependency 'surrealist',       '~> 1.3'
  spec.add_development_dependency 'benchmark-ips',    '~> 2.7'
  spec.add_development_dependency 'rspec',            '~> 3.8'
  spec.add_development_dependency 'armitage-rubocop', '~> 0.12'
  spec.add_development_dependency 'bundler',          '~> 1.17'
  spec.add_development_dependency 'pry',              '~> 0.12'
end
