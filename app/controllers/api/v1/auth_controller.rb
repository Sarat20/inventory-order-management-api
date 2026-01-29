module Api
  module V1
    class AuthController < BaseController
      skip_before_action :authenticate_user!, only: [:login, :register]

      def login
        user = User.find_by(email: params[:email])

       
        unless user&.active? && user.valid_password?(params[:password])
          return render json: { error: "Invalid email or password" }, status: :unauthorized
        end

        request.env["warden"].set_user(user, scope: :user, store: false)
        token = request.env["warden-jwt_auth.token"]

        render json: {
          token: token,
          user: {
            id: user.id,
            name: user.name,
            email: user.email,
            role: user.role,
            status: user.status
          }
        }, status: :ok
      end

      def register
        user = User.new(user_params)

        if user.save
          render json: {
            success: true,
            data: {
              id: user.id,
              name: user.name,
              email: user.email,
              role: user.role,
              status: user.status
            }
          }, status: :created
        else
          render json: {
            success: false,
            errors: user.errors.full_messages
          }, status: :unprocessable_entity
        end
      end

    
      def me
        render json: {
          id: current_user.id,
          name: current_user.name,
          email: current_user.email,
          role: current_user.role,
          status: current_user.status
        }, status: :ok
      end

      def logout
        sign_out(current_user)
        render json: { success: true, message: "Logged out successfully" }, status: :ok
      end

      private

      def user_params
        params.require(:user).permit(:name, :email, :password)
      end
    end
  end
end
