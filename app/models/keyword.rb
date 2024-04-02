class Keyword < ApplicationRecord
  validates :keyword, presence: true, uniqueness: true
end
