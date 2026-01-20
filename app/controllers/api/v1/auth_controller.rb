module Api
  module V1
    class AuthController < ApplicationController
      skip_before_action :authenticate_user!, only: [:login, :register]

      def login
        user = User.find_by(email: params[:email])

        if user&.valid_password?(params[:password])
          request.env["warden"].set_user(user, scope: :user, store: false)
          token = request.env["warden-jwt_auth.token"]

          render json: {
            token: token,
            user: {
              id: user.id,
              name: user.name,
              email: user.email,
              role: user.role
            }
          }, status: :ok
        else
          render json: { error: "Invalid email or password" }, status: :unauthorized
        end
      end


      def register
        user = User.create!(
          name: params[:name],
          email: params[:email],
          password: params[:password],
        )

        render json: {
          success: true,
          data: {
            id: user.id,
            name: user.name,
            email: user.email,
            role: user.role
          }
        }, status: :created
      end

    
      def me
        render json: {
          id: current_user.id,
          name: current_user.name,
          email: current_user.email,
          role: current_user.role,
          status: current_user.status
        }
      end

  
      def logout
        render json: { success: true, message: "Logged out successfully" }, status: :ok
      end
    end
  end
end
