# frozen_string_literal: true

class KeywordSerializer < Panko::Serializer
  attributes :id, :keyword, :adwords, :links, :results, :page_html
end
