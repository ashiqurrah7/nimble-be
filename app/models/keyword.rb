# frozen_string_literal: true

class Keyword < ApplicationRecord
  validates :keyword, presence: true, uniqueness: true
  validates :results, :links, :adwords, :page_html, presence: true
end
