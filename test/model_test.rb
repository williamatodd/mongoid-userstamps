require 'test_helper'

class ModelTest < BaseTest
  test 'should set created_by and updated_by on creation' do
    @user = User.create(name: 'John')
    Mongoid::Userstamps::Config.set_current_user(User, @user)
    @post = Post.create(title: 'Hello')
    assert_equal @user, @post.created_by
    assert_equal @user, @post.updated_by
  end
end

