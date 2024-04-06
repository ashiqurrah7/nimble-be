# frozen_string_literal: true

require 'test_helper'

class FakeController < ApplicationController
  def fake_action
    render json: { message: 'success' }, status: :ok
  end
end

class ApplicationControllerTest < ActionController::TestCase
  def setup
    @controller = FakeController.new
    Rails.application.routes.draw do
      get '/' => 'fake#fake_action'
    end
  end

  def teardown
    Rails.application.reload_routes!
  end

  test 'authorize_user returns authentication error if there are no auth headers present' do
    get :fake_action
    assert_response :unauthorized
    assert_equal 'Authentication error!', parsed_response['message']
  end

  test 'authorize_user returns authentication error if there are no users with the auth token' do
    request.headers['Authorization'] = 'Bearer a1b2c3'
    User.expects(:find_by).with(auth_token: 'a1b2c3').returns(nil)

    get :fake_action
    assert_response :unauthorized
    assert_equal 'Authentication error!', parsed_response['message']
  end

  test 'authenticated user get success response' do
    request.headers['Authorization'] = 'Bearer a1b2c3'
    User.expects(:find_by).with(auth_token: 'a1b2c3').returns(mock)

    get :fake_action
    assert_response :ok
    assert_equal 'success', parsed_response['message']
  end
end
