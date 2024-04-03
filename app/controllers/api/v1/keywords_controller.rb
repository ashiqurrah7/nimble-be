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
    
    if !keyword.blank?
      render json: KeywordSerializer.new.serialize(
        keyword
      ).to_json, status: :ok
    else
      head :not_found
    end
  end

  def create
    csv_file = keyword_params[:csv]

    temp_file = Tempfile.new(["uploaded_#{Time.zone.today.strftime('%b-%d-%Y')}", '.csv'])
    temp_file.binmode

    temp_file.write(csv_file.read)
    temp_file.rewind

    CSV.foreach(temp_file, headers: true) do |row|
      keyword = row['keyword']
      params = GoogleScraper.scrape(keyword)
      Keyword.create(params)
    end

    temp_file.close
    temp_file.unlink

    render json: { message: 'Keywords uploaded successfully' }, status: :created
  end

  def keyword_params
    params.permit(:csv)
  end
end
