# frozen_string_literal: true

class Keyword < ApplicationRecord
  validates :keyword, presence: true, uniqueness: true
end
