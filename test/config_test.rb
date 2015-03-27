require 'test_helper'

class ConfigTest < BaseTest
  test 'should config using block' do
    Mongoid::Userstamps.config do |c|
      c.created_name = :creator
      c.updated_name = :updater
      c.deleted_name = :deleter
      c.user_reader = :get_user
    end
    assert_equal :creator, Mongoid::Userstamps::Config.created_name
    assert_equal :updater, Mongoid::Userstamps::Config.updated_name
    assert_equal :deleter, Mongoid::Userstamps::Config.deleted_name
    assert_equal :get_user, Mongoid::Userstamps::Config.user_reader
  end
end

