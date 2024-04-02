# frozen_string_literal: true

class Api::V1::SessionsController < ApplicationController
  INVALID_USERNAME_OR_PASSWORD = 'Invalid username or password. Please Try again!'

  skip_before_action :authorize_user, only: [:create]

  def create
    user = User.find_by(username: user_params[:username])
    if !user.present?
      render json: { message: INVALID_USERNAME_OR_PASSWORD }, status: :unauthorized
    else
      if user.authenticate(params[:password])
        render json: {
          message: 'Successfully logged in',
          data: {
            username: user.username,
            token: user.auth_token
          }
        }, status: :ok
      else
        render json: { message: INVALID_USERNAME_OR_PASSWORD }, status: :unauthorized
      end
    end
  rescue StandardError => e
    Rails.logger.error("User Login API failed: #{e.message}")
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
