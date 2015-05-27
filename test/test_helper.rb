require 'bundler/setup'
require 'simplecov'
SimpleCov.configure do
  add_filter '/test/'
end
SimpleCov.start if ENV['COVERAGE']

require 'minitest/autorun'
require 'mongoid'
require 'pry'

require File.expand_path("../../lib/mongoid-userstamps", __FILE__)

Mongoid.load!("#{File.dirname(__FILE__)}/mongoid.yml", "test")

Dir["#{File.dirname(__FILE__)}/models/*.rb"].each { |f| require f }

ActiveSupport::TestCase.test_order = :random

class BaseTest < ActiveSupport::TestCase
  teardown do
    Mongoid::Sessions.default.use('mongoid_userstamps_test').drop
    Mongoid::Userstamps::Config.reset
  end
end

