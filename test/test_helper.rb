# frozen_string_literal: true

ENV['RAILS_ENV'] ||= 'test'
require_relative '../config/environment'
require 'rails/test_help'
require 'minitest/unit'
require 'mocha/minitest'
require 'webmock/minitest'

class ActiveSupport::TestCase
  # Run tests in parallel with specified workers
  parallelize(workers: :number_of_processors)

  # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
  fixtures :all

  # Add more helper methods to be used by all tests here...

  def parsed_response
    parsed_data = JSON.parse(response.body)
    parsed_data.is_a?(Hash) ? parsed_data.with_indifferent_access : parsed_data
  end
end
