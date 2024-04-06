# frozen_string_literal: true

class ApplicationController < ActionController::Base
  before_action :authorize_user

  protected

  def authorize_user
    header = request.headers['Authorization']
    return render json: { message: 'Authentication error!' }, status: :unauthorized if !header.present?

    token = header.split(' ').last
    begin
      @current_user = User.find_by(auth_token: token)
      render json: { message: 'Authentication error!' }, status: :unauthorized if !@current_user.present?
    end
  end
end
