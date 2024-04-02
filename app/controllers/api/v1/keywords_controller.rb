# frozen_string_literal: true

require 'tempfile'
require 'csv'

class Api::V1::KeywordsController < ApplicationController
  skip_before_action :authorize_user, only: [:create]

  def create
    csv_file = params[:csv]

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
end
