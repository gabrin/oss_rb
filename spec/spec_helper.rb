ENV["RACK_ENV"] ||= 'test'
require 'rack/test'

require File.expand_path("../../lib/oss_rb.rb", __FILE__)

RSpec.configure do |config|
  config.mock_with :rspec
  config.expect_with :rspec
end
