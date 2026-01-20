class ApplicationController < ActionController::API
    before_action :authenticate_user!
    include Pundit::Authorization
  rescue_from Pundit::NotAuthorizedError do
    render json: { error: "Not authorized" }, status: :forbidden
end
