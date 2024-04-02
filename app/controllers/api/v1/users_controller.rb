class Api::V1::UsersController < ApplicationController
  skip_before_action :authorize_user, only: [:create]

  def create
    User.create!(user_params)
    render json: {
      message: 'User registration successfull',
      data: nil
    }, status: :created
  rescue StandardError => e
    Rails.logger.error("Failed to create user: #{e.message}")
    render json: failed_response(e.message), status: :unprocessable_entity
  end

  private

  def user_params
    params.permit(
      :username,
      :password
    )
  end
end
