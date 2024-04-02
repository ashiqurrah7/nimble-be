# frozen_string_literal: true

class User < ApplicationRecord
  has_secure_password
  has_secure_token :auth_token, length: 30
  validates :username, presence: true, uniqueness: true
end
