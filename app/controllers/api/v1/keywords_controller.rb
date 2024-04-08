# frozen_string_literal: true

require 'tempfile'
require 'csv'

class Api::V1::KeywordsController < ApplicationController
  def index
    keywords = Keyword.all

    render json: Panko::ArraySerializer.new(
      keywords, each_serializer: KeywordSerializer
    ).to_json, status: :ok
  end

  def show
    keyword = Keyword.find_by_id(params[:id])

    if keyword.present?
      render json: KeywordSerializer.new.serialize(
        keyword
      ).to_json, status: :ok
    else
      head :not_found
    end
  end

  # rubocop:disable Metrics/AbcSize
  def create
    csv_file = keyword_params[:csv]
    threads = []

    keywords_chunks = CSV.read(csv_file.path, headers: true).each_slice(10)

    keywords_chunks.each do |chunk|
      threads << Thread.new do
        chunk.each do |row|
          keyword = row['keyword']
          params = GoogleScraper.scrape(keyword)
          Keyword.create(params)
        end
      end
    end

    threads.each(&:join)

    render json: { message: 'Keywords uploaded successfully' }, status: :created
  rescue StandardError => e
    Rails.logger.error("Keywords API failed to fetch results: #{e.message}")
    render json: { message: e.message }, status: :unprocessable_entity
  end
  # rubocop:enable Metrics/AbcSize

  def keyword_params
    params.permit(:csv)
  end
end
