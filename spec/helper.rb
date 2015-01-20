require 'besepa'
require 'rspec'
require 'stringio'
require 'tempfile'
#require 'timecop'
require 'webmock/rspec'


RSpec.configure do |config|
  config.expect_with :rspec do |c|
    c.syntax = :expect
  end
end

TEST_HOST = "http://test.besepa.com"
TEST_BASE_URL = "#{TEST_HOST}/api/1"


def stub_delete(path)
  stub_request(:delete, TEST_BASE_URL + path)
end

def stub_get(path)
  stub_request(:get, TEST_BASE_URL + path)
end

def stub_post(path)
  stub_request(:post, TEST_BASE_URL + path)
end

def stub_put(path)
  stub_request(:put, TEST_BASE_URL + path)
end

def fixture_path
  File.expand_path('../fixtures', __FILE__)
end

def fixture(file)
  File.new(fixture_path + '/' + file)
end

Besepa.configure do |config|
  config.api_key = 'abc123' 
  config.endpoint = TEST_HOST
end