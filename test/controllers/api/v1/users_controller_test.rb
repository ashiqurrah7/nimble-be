# frozen_string_literal: true

require 'test_helper'

class UsersControllerTest < ActionController::TestCase
  def setup
    @controller = Api::V1::UsersController.new
  end

  test 'User creation fails and raises exception' do
    User.expects(:create!)
        .raises(StandardError)

    post :create, params: { username: 'john', password: '123' }
    assert_response :unprocessable_entity
    assert_equal 'StandardError', parsed_response['message']
  end

  test 'User creation succeeds' do
    post :create, params: { username: 'john', password: '123' }
    assert_response :created
    assert_equal 'User registration successfull', parsed_response['message']
  end
end
