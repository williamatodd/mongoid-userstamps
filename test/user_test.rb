require 'test_helper'

class UserTest < BaseTest
  test 'should set as current' do
    @user = User.create(name: 'John')
    Mongoid::Userstamps::Config.set_current_user(User, @user)
    assert_equal @user, Mongoid::Userstamps::Config.current_user(User)
  end
end

