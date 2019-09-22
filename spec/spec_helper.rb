# frozen_string_literal: true

require "bundler/setup"

require "simplecov"
require "coveralls"
SimpleCov.formatter = Coveralls::SimpleCov::Formatter
SimpleCov.start do
  add_filter "/spec"
end
Coveralls.wear!

require "vcr"

require "misp"

require_relative "./support/shared_examples/create_example"
require_relative "./support/shared_examples/delete_example"
require_relative "./support/shared_examples/get_example"
require_relative "./support/shared_examples/list_example"
require_relative "./support/shared_examples/update_example"

RSpec.configure do |config|
  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = ".rspec_status"

  # Disable RSpec exposing methods globally on `Module` and `main`
  config.disable_monkey_patching!

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end
end

ENV["MISP_API_KEY"] = "foo bar" unless ENV.key?("MISP_API_KEY")
ENV["MISP_API_ENDPOINT"] = "http://localhost:5000" unless ENV.key?("MISP_API_ENDPOINT")

VCR.configure do |config|
  config.cassette_library_dir = "spec/fixtures/vcr_cassettes"
  config.configure_rspec_metadata!
  config.hook_into :webmock
  config.ignore_localhost = false

  config.filter_sensitive_data("<API_KEY>") { ENV["MISP_API_KEY"] }
  config.filter_sensitive_data("<API_ENDPOINT>") { ENV["MISP_API_ENDPOINT"] }
end
