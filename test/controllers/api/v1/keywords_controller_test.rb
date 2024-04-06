# frozen_string_literal: true

require 'test_helper'

class KeywordsControllerTest < ActionController::TestCase
  def setup
    request.headers['Authorization'] = 'Bearer a1b2c3'
    User.expects(:find_by).with(auth_token: 'a1b2c3').returns(mock)
    @controller = Api::V1::KeywordsController.new
  end

  test 'index returns list of keywords' do
    keyword_mock = mock(id: '1',
                        keyword: 'ninjas',
                        results: '123',
                        links: '2',
                        adwords: '3',
                        page_html: '!<DOCTYPE html>')
    keyword_list = [keyword_mock]
    Keyword.expects(:all).returns(keyword_list)
    get :index
    assert_response :ok
    assert_equal '1', parsed_response[0]['id']
    assert_equal 'ninjas', parsed_response[0]['keyword']
    assert_equal '123', parsed_response[0]['results']
    assert_equal '2', parsed_response[0]['links']
    assert_equal '3', parsed_response[0]['adwords']
    assert_equal '!<DOCTYPE html>', parsed_response[0]['page_html']
  end

  test 'show doesnt find keyword' do
    Keyword.expects(:find_by_id).returns(nil)
    get :show, params: { id: '1' }
    assert_response :not_found
  end

  test 'show finds keyword' do
    keyword_mock = mock(id: '1',
                        keyword: 'ninjas',
                        results: '123',
                        links: '2',
                        adwords: '3',
                        page_html: '!<DOCTYPE html>')
    Keyword.expects(:find_by_id).returns(keyword_mock)
    get :show, params: { id: '1' }
    assert_response :ok
    assert_equal '1', parsed_response['id']
    assert_equal 'ninjas', parsed_response['keyword']
    assert_equal '123', parsed_response['results']
    assert_equal '2', parsed_response['links']
    assert_equal '3', parsed_response['adwords']
    assert_equal '!<DOCTYPE html>', parsed_response['page_html']
  end
end
