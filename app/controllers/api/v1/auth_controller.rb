class Api::V1::AuthController < ApplicationController
  skip_before_action :authenticate_user!, only: [:login]

  def login
    user = User.find_by(email: params[:email])

    if user&.valid_password?(params[:password])
      token = request.env['warden-jwt_auth.token']

      render json: {
        token: token,
        user: {
          id: user.id,
          name: user.name,
          role: user.role
        }
      }, status: :ok
    else
      render json: { error: "Invalid email or password" }, status: :unauthorized
    end
  end

  def logout
    head :no_content
  end
end
