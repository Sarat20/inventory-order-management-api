class Api::V1::UsersController < ApplicationController
  before_action :authenticate_user!

  def me
    render json: {
      success: true,
      data: UserSerializer.new(current_user).serializable_hash   
    }
  end
end
