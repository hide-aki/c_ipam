# spec/spec_helper.rb
require 'rspec'
require 'rack/test'
require 'database_cleaner'

ENV['RACK_ENV'] = 'test'

require_relative "../server.rb"

module RSpecMixin
  include Rack::Test::Methods
  
  def app() Sinatra::Application end
end

RSpec.configure do |config|

  config.include RSpecMixin

  config.before(:suite) do
    DatabaseCleaner.strategy = :truncation
  end

  config.before(:each) do
    DatabaseCleaner.start
  end

  config.after(:each) do
    DatabaseCleaner.clean
  end
end
