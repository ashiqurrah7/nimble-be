# frozen_string_literal: true

class Api::V1::UsersController < ApplicationController
  skip_before_action :authorize_user, only: [:create]

  def create
    User.create!(user_params)
    render json: {
      message: 'User registration successfull'
    }, status: :created
  rescue StandardError => e
    Rails.logger.error("Failed to create user: #{e.message}")
    render json: { message: e.message }, status: :unprocessable_entity
  end

  private

  def user_params
    params.permit(
      :username,
      :password
    )
  end
end
