# frozen_string_literal: true

lib = File.expand_path('../lib', __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

Gem::Specification.new do |spec|
  spec.required_ruby_version = '>= 2.5.0'

  spec.name = 'serde'
  spec.version = '0.0.1'
  spec.authors = ['Alexander Komarov']
  spec.email = %w[ak@akxcv.com]

  spec.summary = %q(Fast, compiled serializers for Ruby.)
  spec.description = %q(Fast, compiled serializers for Ruby. Powered by serde.rs.)
  spec.homepage = 'https://github.com/akxcv/serde.rb'
  spec.license = 'MIT'

  spec.require_paths = %w[lib]

  spec.files = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end

  spec.add_development_dependency 'bundler', '~> 1.17'
  spec.add_development_dependency 'pry', '~> 0.12'
  spec.add_development_dependency 'rspec', '~> 3.8'
  spec.add_development_dependency 'rubocop', '~> 0.60'
end
