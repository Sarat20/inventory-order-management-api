module Api
  module V1
    class AuthController < BaseController

      skip_before_action :authenticate_user!, only: [:login, :register]

      # NOTE: The login action doesn't check whether the user is active before allowing authentication.
      # If the User model has statuses like inactive or terminated, consider whether those users
      # should be prevented from logging in.
      def login
        user = User.find_by(email: params[:email])

        if user&.valid_password?(params[:password])
          request.env["warden"].set_user(user, scope: :user, store: false)
          token = request.env["warden-jwt_auth.token"]

          render json: {
            token: token,
            user: UserSerializer.new(user).serializable_hash
          }, status: :ok
        else
          render json: { error: "Invalid email or password" }, status: :unauthorized
        end
      end

      # NOTE: User registration uses User.create! without wrapping parameters in user_params.
      # While this works, consider whether using strong parameters would provide an extra layer
      # of protection and consistency with other controllers.
      def register
        user = User.create!(
          name: params[:name],
          email: params[:email],
          password: params[:password],
        )

        render json: {
          success: true,
          data: UserSerializer.new(user).serializable_hash
        }, status: :created
      end

      def me
        render json: UserSerializer.new(current_user).serializable_hash
      end

      def logout
        sign_out(current_user)
        render json: { success: true, message: "Logged out successfully" }, status: :ok
      end
    end
  end
end
