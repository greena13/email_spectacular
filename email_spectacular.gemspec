# frozen_string_literal: true

lib = File.expand_path('lib', __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'email_spectacular/version'

Gem::Specification.new do |spec|
  spec.name          = 'email_spectacular'
  spec.version       = EmailSpectacular::VERSION
  spec.authors       = ['Aleck Greenham']
  spec.email         = ['greenhama13@gmail.com']
  spec.summary       = 'High-level email spec helpers for acceptance, feature and request ' \
                        'tests'
  spec.description   = 'Expressive email assertions that let you succinctly describe when ' \
                        'emails should and should not be sent'
  spec.homepage      = 'https://github.com/greena13/email_spectacular'
  spec.license       = 'MIT'

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(spec)/})
  spec.require_paths = ['lib']

  spec.add_dependency 'actionmailer'
  spec.add_dependency 'capybara', '~> 2.5', '>= 2.5.0'

  spec.add_development_dependency 'bundler', '~> 2'
  spec.add_development_dependency 'guard', '~> 2.1'
  spec.add_development_dependency 'guard-rspec', '~> 4.7'
  spec.add_development_dependency 'rake', '>= 12.3.3'
  spec.add_development_dependency 'rspec', '>= 3.5.0'
end
