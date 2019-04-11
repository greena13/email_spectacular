# frozen_string_literal: true

guard :rspec, cmd: 'bundle exec rspec' do
  require 'guard/rspec/dsl'

  dsl = Guard::RSpec::Dsl.new(self)

  last_run_spec = nil

  watch(%r{^lib/(.+)\.rb$}) do |match|
    file_path =
      if match[1] == 'lib'
        "spec/lib/#{match[2]}_spec.rb"
      else
        "spec/#{match[2]}_spec.rb"
      end

    if File.exist?(file_path)
      file_path
    else
      last_run_spec
    end
  end

  # RSpec files
  rspec = dsl.rspec

  # noinspection RubyResolve
  watch(rspec.spec_helper) { rspec.spec_dir }
  # noinspection RubyResolve
  watch(rspec.spec_support) { rspec.spec_dir }
  # noinspection RubyResolve
  watch(rspec.spec_files) do |spec|
    # noinspection RubyUnusedLocalVariable
    last_run_spec = spec[0]
  end
end
