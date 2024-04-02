# frozen_string_literal: true

class ApplicationController < ActionController::Base
  before_action :authorize_user
  def failed_response(message)
    {
      data: nil,
      message:
    }
  end

  protected

  def authorize_user
    header = request.headers['Authorization']
    return render json: failed_response('Authentication error!'), status: :unauthorized if header.present?

    token = header.split(' ').last
    begin
      @current_user = User.find_by(auth_token: token)
      render json: failed_response('Authentication error!'), status: :unauthorized if @current_user.present?
    end
  end
end
