# frozen_string_literal: true

require 'test_helper'

class SessionsControllerTest < ActionController::TestCase
  def setup
    @controller = Api::V1::SessionsController.new
  end

  test 'create cannot find user and fails' do
    User.expects(:find_by)
        .returns(nil)

    post :create, params: { username: 'john', password: '123' }
    assert_response :unauthorized
    assert_equal 'Invalid username or password. Please Try again!', parsed_response['message']
  end

  test 'create cannot finds user but password is wrong' do
    mock_user = mock
    User.expects(:find_by)
        .returns(mock_user)
    mock_user.expects(:authenticate).returns(false)

    post :create, params: { username: 'john', password: '123' }
    assert_response :unauthorized
    assert_equal 'Invalid username or password. Please Try again!', parsed_response['message']
  end

  test 'create succeeds' do
    mock_user = mock(username: 'john', auth_token: 'a1b2c3')
    User.expects(:find_by)
        .returns(mock_user)
    mock_user.expects(:authenticate).returns(true)

    post :create, params: { username: 'john', password: '123' }
    assert_response :ok
    assert_equal 'Successfully logged in', parsed_response['message']
    assert_equal 'john', parsed_response['data']['username']
    assert_equal 'a1b2c3', parsed_response['data']['token']
  end
end
