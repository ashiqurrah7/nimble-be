# frozen_string_literal: true

require 'open-uri'
require 'nokogiri'

class GoogleScraper
  USER_AGENTS = [
    'Mozilla/5.0 (Windows NT 10.0; Win64; x64) '\
    'AppleWebKit/537.36 (KHTML, like Gecko) Chrome/99.0.9999.999 Safari/537.36',
    'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:99.0) Gecko/20100101 Firefox/99.0',
    'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) '\
    'AppleWebKit/605.1.15 (KHTML, like Gecko) Version/15.1 Safari/605.1.15',
    'Mozilla/5.0 (Windows NT 10.0; Win64; x64) '\
    'AppleWebKit/537.36 (KHTML, like Gecko) Chrome/99.0.9999.999 Safari/537.36 Edg/99.0.999.0'
  ].freeze

  def self.scrape(keyword)
    user_agent = USER_AGENTS.sample
    url = URI.parse("https://www.google.com/search?q=#{URI.encode_www_form_component(keyword)}&gl=us")

    http = Net::HTTP.new(url.host, url.port)
    http.use_ssl = url.scheme == 'https'

    request = Net::HTTP::Get.new(url)
    request['User-Agent'] = user_agent

    response = http.request(request)

    raise "Failed to fetch results. HTTP status code: #{response.code}" unless response.code == '200'

    doc = Nokogiri::HTML(response.body)

    keyword_params(keyword, doc)
  end

  def self.keyword_params(keyword, doc)
    adwords = doc.css('.ads-ad').count
    links = doc.css('a').count
    search_results = doc.at('div#result-stats').text.strip.split(' ')[1]
    page_html = doc.to_html

    { keyword:,
      adwords:,
      links:,
      results: search_results,
      page_html: }
  end
end
