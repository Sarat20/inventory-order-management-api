class Api::V1::UsersController < ApplicationController
  def me
    render json: {
      id: current_user.id,
      name: current_user.name,
      email: current_user.email,
      role: current_user.role,
      status: current_user.status
    }
  end
end
